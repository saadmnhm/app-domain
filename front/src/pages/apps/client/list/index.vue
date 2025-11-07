<script setup>
import { ref, computed, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import clientService from '@/services/clientService'
import contactclientmodal from '@/pages/apps/client/components/contactclientmodal.vue'
import clientmodal from '@/pages/apps/client/components/clientmodal.vue'

const router = useRouter()
const clients = ref([])
const isLoading = ref(false)
const viewMode = ref('table') 
const searchQuery = ref('')
const totalClients = ref(0)
const categories = ref([])

const currentPage = ref(1)
const pageSize = ref(10)
const pageSizeOptions = [5, 10, 15, 20]

const isAddEditClientDialogVisible = ref(false)
const isDeleteDialogVisible = ref(false)
const selectedClient = ref(null)
const clientToDelete = ref(null)

const isSubmitting = ref(false)
const clientModalRef = ref(null)
const contactModalRef = ref(null)
const clientIdForContact = ref(null)
const clientForm = ref({})

const editMode = computed(() => !!selectedClient.value?.id)
const dialogTitle = computed(() => editMode.value ? 'Edit Client' : 'Add New Client')


const toggleViewMode = () => {
  viewMode.value = viewMode.value === 'card' ? 'table' : 'card'
}

const fetchClients = async () => {
  isLoading.value = true
  
  try {
    const params = {
      page: currentPage.value,
      per_page: pageSize.value,
      search: searchQuery.value,
    }
    
    const response = await clientService.getClients(params)
    
    if (Array.isArray(response)) {
      clients.value = response
      totalClients.value = response.length
    } else if (response && typeof response === 'object') {
      clients.value = response.data || []
      totalClients.value = response.total || response.meta?.total || 0
    } else {
      clients.value = []
      totalClients.value = 0
    }

    console.log("First client data:", clients.value[0]);
  } catch (error) {
    console.error('Error fetching clients:', error)
    clients.value = []
  } finally {
    isLoading.value = false
  }
}

const fetchCategories = async () => {
  try {
    const response = await clientService.getCategories({ withTrashed: true })
    
    if (Array.isArray(response)) {
      categories.value = response
    } else if (response && typeof response === 'object') {
      categories.value = response.data || []
    } else {
      categories.value = []
    }
  } catch (error) {
    console.error('Error fetching categories:', error)
    categories.value = []
  }
}

const getCategoryName = (categoryId) => {
  const category = categories.value.find(cat => cat.id === categoryId)
  return category ? category.label : 'Unknown Category'
}

const editClient = (client) => {
  selectedClient.value = { ...client }
  isAddEditClientDialogVisible.value = true
}

const confirmDelete = (client) => {
  clientToDelete.value = client
  isDeleteDialogVisible.value = true
}

const deleteClient = async () => {
  if (!clientToDelete.value?.id) return
  
  try {
    await clientService.deleteClient(clientToDelete.value.id)
    fetchClients()
    isDeleteDialogVisible.value = false
    clientToDelete.value = null
  } catch (error) {
    console.error('Error deleting client:', error)
  }
}

const submitCombinedForm = async () => {
  try {
    isSubmitting.value = true
    
    const clientResponse = await clientModalRef.value.submitForm()
    
    const clientId = editMode.value ? selectedClient.value.id : clientResponse.data.id
    clientIdForContact.value = clientId
    
    await nextTick()
    
    if (contactModalRef.value) {
      await contactModalRef.value.submitForm(clientId)
    }
    
    closeModals()
    fetchClients()
    
  } catch (error) {
    console.error('Error saving client and contact:', error)
  } finally {
    isSubmitting.value = false
  }
}

const handleClientSaved = (client) => {
  console.log('Client saved:', client)
  
  if (editMode.value) {
    selectedClient.value = { ...selectedClient.value, ...client }
  } else {
    selectedClient.value = client
  }
  
  clientIdForContact.value = client.id
}

const handleContactSaved = () => {
  closeModals()
  fetchClients()
}

const handleFormCanceled = () => {
  closeModals()
}

const closeModals = () => {
  isAddEditClientDialogVisible.value = false
  selectedClient.value = null
}

const handleSearch = () => {
  currentPage.value = 1
  fetchClients()
}



const addNewClient = () => {
  selectedClient.value = null
  isAddEditClientDialogVisible.value = true
}

onMounted(() => {
  fetchClients()
  fetchCategories()
})
</script>

<template>
  <VCard>
    <!-- Header -->
    <VCardItem>
      <VCardTitle>Clients</VCardTitle>
      
      <template #append>
        <div class="d-flex align-center gap-4">
          <!-- View Toggle Button -->
          <VBtn
            variant="outlined"
            :color="viewMode === 'table' ? '#18134c' : '#18134c'"
            class="me-2 "
            @click="toggleViewMode"
          >
            <VIcon :icon="viewMode === 'table' ? 'tabler-layout-grid' : 'tabler-table'" class="me-2" />
            {{ viewMode === 'table' ? 'Card View' : 'Table View' }}
          </VBtn>
          
          <!-- Search -->
          <VTextField
            v-model="searchQuery"
            density="compact"
            placeholder="Search clients"
            append-inner-icon="tabler-search"
            single-line
            hide-details
            @keyup.enter="handleSearch"
            style="max-width: 300px;min-width: 250px;"
          />
          
          <!-- Add New Button -->
          <VBtn
            prepend-icon="tabler-plus"
            color="primary"
            @click="addNewClient"
          >
            Add New Client
          </VBtn>
        </div>
      </template>
    </VCardItem>

    <VDivider />

    <!-- Card View -->
    <VRow v-if="!isLoading && viewMode === 'card'" class="pa-3">
      <VCol 
        v-for="item in clients" 
        :key="item.id" 
        cols="12" 
        md="6" 
        lg="4" 
        xl="3"
      >
        <VCard class="h-100">
          <VCardItem>
            <template #prepend>
              <VAvatar 
                color="primary" 
                variant="tonal" 
                size="42"
                class="me-3"
              >
                <span>{{ item.raison_sociale?.charAt(0).toUpperCase() }}</span>
              </VAvatar>
            </template>
            
            <VCardTitle>
              {{ item.raison_sociale }}
            </VCardTitle>
            
            <template #append>
              <VChip
                size="small"
                color="primary"
                class="text-capitalize"
              >
                {{ getCategoryName(item.categories_id) }}
              </VChip>
            </template>
          </VCardItem>
          
          <VCardText class="pb-2">
            <!-- Contact Info -->
            <div class="d-flex align-center mb-2">
              <VIcon icon="tabler-mail" size="16" class="me-2" />
              <span class="text-body-2">{{ item.email }}</span>
            </div>
            
            <div v-if="item.phone" class="d-flex align-center mb-2">
              <VIcon icon="tabler-phone" size="16" class="me-2" />
              <span class="text-body-2">{{ item.phone }}</span>
            </div>
            
            <div v-if="item.website" class="d-flex align-center mb-2">
              <VIcon icon="tabler-world" size="16" class="me-2" />
              <a :href="item.website" target="_blank" class="text-body-2">{{ item.website }}</a>
            </div>
            

          </VCardText>
          
          <VDivider />
          
          <VCardActions>
            <VBtn
              variant="text"
              size="small"
              color="default"
              @click="router.push({ name: 'apps-client-view-id', params: { id: item.id }})"
            >
              <VIcon icon="tabler-eye" class="me-1" size="16" />
              View
            </VBtn>
            
            <VSpacer />
            
            <VBtn
              variant="text"
              size="small"
              color="primary"
              @click="router.push({ name: 'apps-client-view-id', params: { id: item.id }})"
            >
              <VIcon icon="tabler-edit" class="me-1" size="16" />
              Edit
            </VBtn>
            
            <VBtn
              variant="text"
              size="small"
              color="error"
              @click="confirmDelete(item)"
            >
              <VIcon icon="tabler-trash" class="me-1" size="16" />
              Delete
            </VBtn>
          </VCardActions>
        </VCard>
      </VCol>
    </VRow>

    <!-- Table View -->
    <div v-if="!isLoading && viewMode === 'table'" class="pa-4">
      <VDataTable
        :headers="[
          { title: 'Company', key: 'raison_sociale', sortable: true },
          { title: 'Email', key: 'email', sortable: true },
          { title: 'Website', key: 'website', sortable: true },
          { title: 'Category', key: 'category', sortable: true },
          { title: 'Actions', key: 'actions', sortable: false, align: 'end' }
        ]"
        :items="clients"
      >
        <!-- Company column -->
        <template #item.raison_sociale="{ item }">
          <div class="d-flex align-center">
            <VAvatar size="32" color="primary" variant="tonal" class="me-2">
              {{ item.raison_sociale.charAt(0).toUpperCase() }}
            </VAvatar>
            <span>{{ item.raison_sociale }}</span>
          </div>
        </template>
        
        <!-- First name column -->
        <template #item.contact.first_name="{ item }">
          <span v-if="item.contact">
            {{ item.contact.first_name || item.contact.firstname || '-' }}
          </span>
          <span v-else>-</span>
        </template>
        
        <!-- Website column -->
        <template #item.website="{ item }">
          <a v-if="item.website" :href="item.website" target="_blank" class="text-decoration-none">
            <VIcon size="16" icon="tabler-external-link" class="me-1" />
            {{ item.website.replace(/^https?:\/\/(www\.)?/, '') }}
          </a>
          <span v-else>-</span>
        </template>
        
        <!-- Category column -->
        <template #item.category="{ item }">
          <VChip
            size="small"
            color="primary"
            class="text-capitalize"
          >
            {{ getCategoryName(item.categories_id) }}
          </VChip>
        </template>
        
        <!-- Actions column -->
        <template #item.actions="{ item }">
          <VBtn
            icon
            variant="text"
            size="small"
            color="default"
            @click="router.push({ name: 'apps-client-view-id', params: { id: item.id }})"
          >
            <VIcon size="18" icon="tabler-eye" />
          </VBtn>
          
          
          <VBtn
            icon
            variant="text"
            size="small"
            color="error"
            @click="confirmDelete(item)"
          >
            <VIcon size="18" icon="tabler-trash" />
          </VBtn>
        </template>
      </VDataTable>
    </div>
    
    <!-- Loading State -->
    <VRow v-if="isLoading" class="pa-3">
      <VCol v-for="n in 3" :key="n" cols="12" md="6" lg="4" xl="3" v-show="viewMode === 'card'">
        <VCard>
          <VCardItem>
            <VSkeleton type="avatar" size="48" class="me-3" />
            <VSkeleton type="text" width="70%" />
          </VCardItem>
          <VCardText>
            <VSkeleton type="text" class="mb-2" />
            <VSkeleton type="text" class="mb-2" />
            <VSkeleton type="text" width="40%" />
          </VCardText>
          <VCardActions>
            <VSkeleton type="button" />
            <VSpacer />
            <VSkeleton type="button" />
            <VSkeleton type="button" />
          </VCardActions>
        </VCard>
      </VCol>
      
      <VCol cols="12" v-show="viewMode === 'table'">
        <VSkeleton type="table" />
      </VCol>
    </VRow>
    
    <!-- Pagination -->
    <!-- <div v-if="clients.length > 0" class="d-flex align-center justify-space-between px-6 py-4">
      <div>
        <span class="text-body-2 text-medium-emphasis">
          Showing {{ (currentPage - 1) * pageSize + 1 }} to {{ Math.min(currentPage * pageSize, totalClients) }} of {{ totalClients }} entries
        </span>
        
        <VSelect
          v-model="pageSize"
          :items="pageSizeOptions"
          variant="outlined"
          density="compact"
          hide-details
          class="d-inline-block ms-4"
          style="width: 80px;"
          @update:modelValue="onPageSizeChange"
        />
      </div>
      
      <VPagination
        v-model="currentPage"
        :length="Math.ceil(totalClients / pageSize)"
        :total-visible="5"
        @update:modelValue="onPageChange"
      />
    </div> -->
  </VCard>
  
  <!-- Add/Edit Client Dialog -->
  <VDialog
    v-model="isAddEditClientDialogVisible"
    max-width="900px"
    persistent
  >
    <VCard>
      <VCardTitle class="d-flex justify-space-between align-center pa-4">
        {{ dialogTitle }}
        
        <VBtn
          icon
          variant="text"
          color="default"
          @click="closeModals"
        >
          <VIcon size="24" icon="tabler-x" />
        </VBtn>
      </VCardTitle>
      
      <VDivider />
      
      <VCardText class="pa-4">
        <!-- Keep both components visible at the same time -->
        <clientmodal  
          ref="clientModalRef"
          :clientData="selectedClient || {}"
          :isEditMode="editMode"
          @saved="handleClientSaved"
          @canceled="handleFormCanceled"
          :hideActions="true"
        />

        <VDivider class="my-4" />
        
        <contactclientmodal
          ref="contactModalRef"
          :clientId="selectedClient?.id || clientIdForContact" 
          :contactData="selectedClient?.contact || {}"
          :isEditMode="editMode && selectedClient?.contact"
          @saved="handleContactSaved"
          @canceled="handleFormCanceled"
          :hideActions="true"
        />
        
        <!-- Combined action buttons -->
        <div class="d-flex justify-end gap-3 mt-4">
          <VBtn
            variant="outlined"
            color="secondary"
            @click="closeModals"
          >
            Cancel
          </VBtn>
          
          <VBtn
            color="primary"
            @click="submitCombinedForm"
            :loading="isSubmitting"
          >
            {{ editMode ? 'Update' : 'Create' }}
          </VBtn>
        </div>
      </VCardText>
    </VCard>
  </VDialog>
  
  <!-- Delete Confirmation Dialog -->
  <VDialog
    v-model="isDeleteDialogVisible"
    max-width="500"
  >
    <VCard>
      <VCardTitle class="text-h5">Delete Client</VCardTitle>
      
      <VCardText>
        Are you sure you want to delete the client <strong>{{ clientToDelete?.raison_sociale }}</strong>?<br>
        This action cannot be undone.
      </VCardText>
      
      <VCardActions>
        <VSpacer />
        
        <VBtn
          color="secondary"
          variant="text"
          @click="isDeleteDialogVisible = false"
        >
          Cancel
        </VBtn>
        
        <VBtn
          color="error"
          variant="elevated"
          @click="deleteClient"
        >
          Delete
        </VBtn>
      </VCardActions>
    </VCard>
  </VDialog>
</template>

<style scoped>
.sortable-chip {
  cursor: pointer;
  transition: all 0.2s ease;
}

.sortable-chip:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}
</style>
