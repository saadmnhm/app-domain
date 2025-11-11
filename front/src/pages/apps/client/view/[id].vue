<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import clientService from '@/services/clientService'
import clientContactService from '@/services/clientcontactService'
import clientmodal from '@/pages/apps/client/components/clientmodal.vue'
import contactclientmodal from '@/pages/apps/client/components/contactclientmodal.vue'

const route = useRoute()
const router = useRouter()
const clientId = computed(() => route.params.id)

const client = ref(null)
const contacts = ref([])
const isLoading = ref(true)
const isContactDialogVisible = ref(false)
const isDeleteContactDialogVisible = ref(false)
const contactToDelete = ref(null)
const editingContact = ref(null)
const isClientDialogVisible = ref(false)
const clientModalRef = ref(null)

const clientHistory = ref([])

const isSubmittingClient = ref(false)

const fetchClient = async () => {
  isLoading.value = true
  
  try {
    const response = await clientService.getClient(clientId.value)
    client.value = response
    
    await fetchContacts()
  } catch (error) {
    console.error('Error fetching client:', error)
  } finally {
    isLoading.value = false
  }
}
const sortedContacts = computed(() => {
  return (contacts.value ?? []).slice().sort((a, b) => {
    const ai = Number(a?.is_responsable || 0)
    const bi = Number(b?.is_responsable || 0)
    if (bi !== ai) return bi - ai
    return (b?.id || 0) - (a?.id || 0)
  })
})
const fetchContacts = async () => {
  try {
    const response = await clientContactService.getContactsByClient(clientId.value)
    contacts.value = response.data || response || []
  } catch (error) {
    console.error('Error fetching contacts:', error)
  }
}

const fetchClientHistory = async () => {
  try {


    clientHistory.value = [
      {
        id: 1,
        type: 'creation',
        timestamp: client.value?.created_at,
        description: `${client.value?.raison_sociale} was created in the system`,
        user: 'System'
      }
    ]

    if (client.value?.updated_at && client.value?.updated_at !== client.value?.created_at) {
      clientHistory.value.push({
        id: 2,
        type: 'update',
        timestamp: client.value?.updated_at,
        description: `Client information was updated`,
        user: 'System'
      })
    }

    contacts.value.forEach((contact, index) => {
      clientHistory.value.push({
        id: 3 + index,
        type: 'contact_added',
        timestamp: contact.created_at,
        description: `Contact ${contact.firstname || contact.first_name} ${contact.lastname || contact.last_name} was added`,
        contact: contact,
        user: 'System'
      })
      
      if (contact.updated_at && contact.updated_at !== contact.created_at) {
        clientHistory.value.push({
          id: 100 + index,
          type: 'contact_updated',
          timestamp: contact.updated_at,
          description: `Contact ${contact.firstname || contact.first_name} ${contact.lastname || contact.last_name} was updated`,
          contact: contact,
          user: 'System'
        })
      }
    })

    clientHistory.value.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp))
  } catch (error) {
    console.error('Error fetching client history:', error)
  }
}

const formatDate = (dateString) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  }).format(date)
}

const openAddContactDialog = () => {
  isContactDialogVisible.value = true
}

const handleContactSaved = () => {
  closeContactDialog()
  fetchContacts() 
}

const handleContactCanceled = () => {
  closeContactDialog()
}
const toggleContactResponsable = async (contact) => {
  if (!contact || !contact.id) return

  const previous = !!contact.is_responsable
  const newValue = !previous ? 1 : 0

  const other = contacts.value.find(c => c.id !== contact.id && Boolean(Number(c.is_responsable)))
  if (newValue === 1 && other) {
    other.is_responsable = 0
  }
  contact.is_responsable = newValue

  try {
    await clientContactService.updateContact(contact.id, { is_responsable: newValue })

    if (newValue === 1 && other) {
      try {
        await clientContactService.updateContact(other.id, { is_responsable: 0 })
      } catch (err) {
        console.error('Failed to unset previous responsable on server:', err)
      }
    }
  } catch (error) {
    console.error('Error updating contact responsable flag:', error)
    if (other) other.is_responsable = Boolean(Number(other.is_responsable)) ? 1 : 0
    contact.is_responsable = previous ? 1 : 0
  }
}
const confirmDeleteContact = (contact) => {
  contactToDelete.value = contact
  isDeleteContactDialogVisible.value = true
}

const deleteContact = async () => {
  if (!contactToDelete.value?.id) return
  
  try {
    await clientContactService.deleteContact(contactToDelete.value.id)
    
    clientHistory.value.unshift({
      id: Date.now(),
      type: 'contact_deleted',
      timestamp: new Date().toISOString(),
      description: `Contact ${contactToDelete.value.firstname || contactToDelete.value.first_name} ${contactToDelete.value.lastname || contactToDelete.value.last_name} was deleted`,
      user: 'Current User'
    })
    
    fetchContacts()
  } catch (error) {
    console.error('Error deleting contact:', error)
  } finally {
    isDeleteContactDialogVisible.value = false
    contactToDelete.value = null
  }
}

const editClient = () => {
  isClientDialogVisible.value = true
}

const handleClientSaved = (updatedClient) => {
  isClientDialogVisible.value = false
  
  if (updatedClient) {
    client.value = { ...client.value, ...updatedClient }
  }
  
  fetchClient()
}

const handleClientCanceled = () => {
  isClientDialogVisible.value = false
}

const goBack = () => {
  router.push('/apps/client/list')
}

const editContact = (contact) => {
  editingContact.value = contact
  isContactDialogVisible.value = true
}

const closeContactDialog = () => {
  isContactDialogVisible.value = false
  editingContact.value = null
}

const submitClientForm = async () => {
  isSubmittingClient.value = true
  
  try {
    await clientModalRef.value.submitForm()
    
    isClientDialogVisible.value = false
  } catch (error) {
    console.error('Error submitting client form:', error)
  } finally {
    isSubmittingClient.value = false
  }
}

onMounted(() => {
  fetchClient().then(() => {
    fetchClientHistory()
  })
})

watch([client, contacts], ([newClient, newContacts]) => {
  if (newClient && newContacts) {
    fetchClientHistory()
  }
}, { deep: true })

const getHistoryItemColor = (type) => {
  switch (type) {
    case 'creation':
      return 'success'
    case 'update':
      return 'info'
    case 'contact_added':
      return 'primary'
    case 'contact_updated':
      return 'warning'
    case 'contact_deleted':
      return 'error'
    default:
      return 'secondary'
  }
}

const getHistoryItemTitle = (type) => {
  switch (type) {
    case 'creation':
      return 'Client Created'
    case 'update':
      return 'Client Updated'
    case 'contact_added':
      return 'Contact Added'
    case 'contact_updated':
      return 'Contact Updated'
    case 'contact_deleted':
      return 'Contact Deleted'
    default:
      return 'Client Event'
  }
}
</script>

<template>
  <div>
    <!-- Header -->
    <VRow>
      <VCol>
        <div class="d-flex flex-wrap gap-4 align-center justify-space-between mb-6">
          <div>
            <h2 class="text-h4">
              {{ isLoading ? 'Loading...' : client?.raison_sociale }}
            </h2>
            <VBreadcrumbs
              :items="[
                {
                  title: 'Client List',
                  to: '/apps/client/list',
                  disabled: false,
                },
                {
                  title: client?.raison_sociale || 'Client Details',
                  disabled: true,
                },
              ]"
            />
          </div>
          
          <div class="d-flex gap-2">
            <VBtn
              variant="outlined"
              color="default"
              @click="goBack"
            >
              <VIcon icon="tabler-arrow-left" class="me-2" />
              Back to List
            </VBtn>

            <VBtn
              color="primary"
              @click="editClient"
            >
              <VIcon icon="tabler-edit" class="me-2" />
              Edit Client
            </VBtn>
          </div>
        </div>
      </VCol>
    </VRow>

    <!-- Loading State -->
    <VCard v-if="isLoading">
      <VCardText>
        <div class="d-flex justify-center align-center" style="height: 300px;">
          <VProgressCircular
            indeterminate
            color="primary"
          />
        </div>
      </VCardText>
    </VCard>
    
    <!-- Client Information -->
    <VRow v-else>
      <VCol cols="12" md="5">
        <VCard class="mb-4">
          <VCardItem>
            <template #prepend>
              <VAvatar
                size="64"
                rounded
                color="primary"
                variant="tonal"
                class="me-4"
              >
                {{ client?.raison_sociale?.charAt(0).toUpperCase() }}
              </VAvatar>
            </template>

            <VCardTitle>
              {{ client?.raison_sociale }}
              <VChip
                size="small"
                color="primary"
                class="text-capitalize ms-3"
              >
                {{ client?.category?.label || 'Uncategorized' }}
              </VChip>
              <VChip
                  size="small"
                  color="primary"
                  class="text-capitalize ms-3"
              >
                  {{ client?.domain?.label || 'Uncategorized' }}
              </VChip>
            </VCardTitle>



            <VCardSubtitle>
              Client #{{ client?.id }}
            </VCardSubtitle>
          </VCardItem>

          <VDivider />

          <VCardText>
            <h4 class="text-h6 mb-3">Basic Information</h4>
            
            <div class="d-flex align-center mb-3">
              <VIcon 
                icon="tabler-mail"
                color="primary" 
                class="me-3"
              />
              <div>
                <p class="text-caption mb-0 text-medium-emphasis">Email</p>
                <p class="mb-0">{{ client?.email || '-' }}</p>
              </div>
            </div>

            <div class="d-flex align-center mb-3">
              <VIcon 
                icon="tabler-phone"
                color="primary" 
                class="me-3"
              />
              <div>
                <p class="text-caption mb-0 text-medium-emphasis">Phone</p>
                <p class="mb-0">{{ client?.phone || '-' }}</p>
              </div>
            </div>

            <div class="d-flex align-center mb-3">
              <VIcon 
                icon="tabler-world"
                color="primary" 
                class="me-3"
              />
              <div>
                <p class="text-caption mb-0 text-medium-emphasis">Website</p>
                <p class="mb-0">
                  <a v-if="client?.website" :href="client.website" target="_blank">
                    {{ client.website.replace(/^https?:\/\/(www\.)?/, '') }}
                    <VIcon icon="tabler-external-link" size="16" />
                  </a>
                  <span v-else>-</span>
                </p>
              </div>
            </div>

            <div class="d-flex align-center mb-3">
              <VIcon 
                icon="tabler-calendar"
                color="primary" 
                class="me-3"
              />
              <div>
                <p class="text-caption mb-0 text-medium-emphasis">Integration Date</p>
                <p class="mb-0">{{ formatDate(client?.date_integration) }}</p>
              </div>
            </div>

            <h4 class="text-h6 mt-6 mb-3">Fiscal Information</h4>
            
            <div class="d-flex flex-wrap">
              <div class="me-8 mb-3">
                <p class="text-caption mb-1 text-medium-emphasis">ICE</p>
                <p class="font-weight-medium">{{ client?.ice || '-' }}</p>
              </div>

              <div class="me-8 mb-3">
                <p class="text-caption mb-1 text-medium-emphasis">IF</p>
                <p class="font-weight-medium">{{ client?.if || '-' }}</p>
              </div>

              <div class="me-8 mb-3">
                <p class="text-caption mb-1 text-medium-emphasis">Patente</p>
                <p class="font-weight-medium">{{ client?.patente || '-' }}</p>
              </div>

              <div class="mb-3">
                <p class="text-caption mb-1 text-medium-emphasis">CNSS</p>
                <p class="font-weight-medium">{{ client?.cnss || '-' }}</p>
              </div>
            </div>
          </VCardText>
        </VCard>
      </VCol>

      <VCol cols="12" md="7">
        <!-- Contacts Card -->
        <VCard>
          <VCardItem>
            <VCardTitle>
              Contacts
              <VChip
                size="small"
                color="primary"
                class="ms-2"
              >
                {{ contacts.length }}
              </VChip>
            </VCardTitle>

            <template #append>
              <VBtn
                color="primary"
                prepend-icon="tabler-plus"
                @click="openAddContactDialog"
              >
                Add Contact
              </VBtn>
            </template>
          </VCardItem>

          <VDivider />

          <VCardText v-if="contacts.length === 0" class="text-center pa-8">
            <VIcon
              icon="tabler-users"
              size="48"
              color="secondary"
              class="mb-3"
            />
            <h4 class="text-h6 mb-2">No Contacts Available</h4>
            <p class="mb-4">This client doesn't have any contacts yet.</p>
            <VBtn
              color="primary"
              @click="openAddContactDialog"
            >
              Add First Contact
            </VBtn>
          </VCardText>

          <div v-else>
            <VList>
              <VListItem
                v-for="contact in sortedContacts"
                :key="contact.id"
                class="py-3"
              >
                <template #prepend>
                  <VAvatar
                    color="primary"
                    variant="tonal"
                    class="me-3"
                  >
                    {{ contact.firstname?.charAt(0).toUpperCase() || contact.first_name?.charAt(0).toUpperCase() }}
                  </VAvatar>
                </template>

                <VListItemTitle class="d-flex align-center mb-1">
                  {{ contact.firstname || contact.first_name }} 
                  {{ contact.lastname || contact.last_name }}
                  <VChip
                    v-if="contact.is_responsable"
                    size="small"
                    color="success"
                    class="ms-2"
                  >
                    Primary
                  </VChip>
                </VListItemTitle>

                <VListItemSubtitle>
                  <div class="d-flex align-center mb-1">
                    <VIcon icon="tabler-briefcase" size="14" class="me-1" />
                    {{ contact.fonction || '-' }}
                  </div>
                  <div class="d-flex align-center mb-1">
                    <VIcon icon="tabler-mail" size="14" class="me-1" />
                    {{ contact.email || '-' }}
                  </div>
                  <div class="d-flex align-center">
                    <VIcon icon="tabler-phone" size="14" class="me-1" />
                    {{ contact.phone || '-' }}
                  </div>
                </VListItemSubtitle>

                <template #append>
                  <div class="d-flex gap-2">
                    <VBtn
                      icon
                      variant="text"
                      :color="contact.is_responsable ? 'success' : 'default'"
                      size="small"
                      @click="toggleContactResponsable(contact)"
                    >
                      <VIcon icon="tabler-phone" />
                    </VBtn>
                    
                    <VBtn
                      icon
                      variant="text"
                      color="default"
                      size="small"
                      @click="editContact(contact)"
                    >
                      <VIcon icon="tabler-edit" />
                    </VBtn>

                    <VBtn
                      icon
                      variant="text"
                      color="error"
                      size="small"
                      @click="confirmDeleteContact(contact)"
                    >
                      <VIcon icon="tabler-trash" />
                    </VBtn>
                  </div>
                </template>
              </VListItem>
            </VList>
          </div>
        </VCard>
        
        <!-- Client History (timeline, notes, etc) -->
        <VCard class="mt-4">
          <VCardItem>
            <VCardTitle>
              Client History
              <VChip
                size="small"
                color="primary"
                class="ms-2"
              >
                {{ clientHistory.length }}
              </VChip>
            </VCardTitle>
          </VCardItem>
          
          <VDivider />
          
          <VCardText>
            <VTimeline side="end" line-thickness="2" line-color="primary" truncate-line="both">
              <VTimelineItem
                v-for="(item, index) in clientHistory"
                :key="item.id"
                :dot-color="getHistoryItemColor(item.type)"
                size="small"
                fill-dot
              >
                <template #opposite>
                  <span class="text-caption">{{ formatDate(item.timestamp) }}</span>
                </template>
                <div class="d-flex justify-space-between align-center flex-wrap">
                  <span class="text-body-1 font-weight-medium">{{ getHistoryItemTitle(item.type) }}</span>
                  <VChip
                    size="x-small"
                    :color="getHistoryItemColor(item.type)"
                    class="ms-2"
                  >
                    {{ item.user }}
                  </VChip>
                </div>
                <p class="text-body-2 mb-0">
                  {{ item.description }}
                </p>
                
                <!-- Show contact details for contact-related history items -->
                <div v-if="item.contact" class="mt-2 pa-2 rounded ">
                  <div class="d-flex align-center">
                    <VAvatar size="24" color="primary" variant="tonal" class="me-2">
                      {{ item.contact.firstname?.charAt(0).toUpperCase() || item.contact.first_name?.charAt(0).toUpperCase() }}
                    </VAvatar>
                    <span>{{ item.contact.firstname || item.contact.first_name }} {{ item.contact.lastname || item.contact.last_name }}</span>
                    
                    <!-- Show contact role/function if available -->
                    <VChip v-if="item.contact.fonction" size="x-small" class="ms-2">
                      {{ item.contact.fonction }}
                    </VChip>
                  </div>
                </div>
              </VTimelineItem>
              
              <VTimelineItem
                v-if="clientHistory.length === 0"
                dot-color="secondary"
                size="small"
              >
                <div class="text-center py-3">
                  <p class="text-body-1 mb-0">No history available for this client</p>
                </div>
              </VTimelineItem>
            </VTimeline>
          </VCardText>
        </VCard>
      </VCol>
    </VRow>
    
    <!-- Add Contact Dialog -->
    <VDialog
      v-model="isContactDialogVisible"
      max-width="700px"
      persistent
    >
      <VCard>
        <VCardTitle class="d-flex justify-space-between align-center pa-4">
          {{ editingContact ? 'Edit Contact' : 'Add New Contact' }}
          
          <VBtn
            icon
            variant="text"
            color="default"
            @click="closeContactDialog"
          >
            <VIcon size="24" icon="tabler-x" />
          </VBtn>
        </VCardTitle>
        
        <VDivider />
        
        <VCardText class="pa-4">
          <contactclientmodal
            :clientId="clientId"
            :contactData="editingContact || {}"
            :isEditMode="!!editingContact"
            @saved="handleContactSaved"
            @canceled="handleContactCanceled"
          />
        </VCardText>
      </VCard>
    </VDialog>
    
    <!-- Delete Contact Confirmation Dialog -->
    <VDialog
      v-model="isDeleteContactDialogVisible"
      max-width="500"
    >
      <VCard>
        <VCardTitle class="text-h5">Delete Contact</VCardTitle>
        
        <VCardText>
          Are you sure you want to delete the contact 
          <strong>
            {{ contactToDelete?.firstname || contactToDelete?.first_name }} 
            {{ contactToDelete?.lastname || contactToDelete?.last_name }}
          </strong>?<br>
          This action cannot be undone.
        </VCardText>
        
        <VCardActions>
          <VSpacer />
          
          <VBtn
            color="secondary"
            variant="text"
            @click="isDeleteContactDialogVisible = false"
          >
            Cancel
          </VBtn>
          
          <VBtn
            color="error"
            variant="elevated"
            @click="deleteContact"
          >
            Delete
          </VBtn>
        </VCardActions>
      </VCard>
    </VDialog>

    <!-- Edit Client Dialog -->
    <VDialog
      v-model="isClientDialogVisible"
      max-width="900px"
      persistent
    >
      <VCard>
        <VCardTitle class="d-flex justify-space-between align-center pa-4">
          Edit Client
          
          <VBtn
            icon
            variant="text"
            color="default"
            @click="isClientDialogVisible = false"
          >
            <VIcon size="24" icon="tabler-x" />
          </VBtn>
        </VCardTitle>
        
        <VDivider />
        
        <VCardText class="pa-4">
          <clientmodal
            ref="clientModalRef"
            :clientData="client || {}"
            :isEditMode="true"
            @saved="handleClientSaved"
            @canceled="handleClientCanceled"
          />
        </VCardText>
        <VCardActions class="pa-4 pt-0">
          <VSpacer />
          
          <VBtn
            color="secondary"
            variant="tonal"
            @click="handleClientCanceled"
            class="me-3"
            :disabled="isSubmittingClient"
          >
            Cancel
          </VBtn>
          
          <VBtn
            color="primary"
            variant="elevated"
            @click="submitClientForm"
            :loading="isSubmittingClient"
          >
            Save Changes
          </VBtn>
        </VCardActions>
      </VCard>
    </VDialog>
  </div>
</template>

<style scoped>
.v-list-item {
  border-bottom: 1px solid rgba(var(--v-border-color), var(--v-border-opacity));
}

.v-list-item:last-child {
  border-bottom: none;
}
</style>
