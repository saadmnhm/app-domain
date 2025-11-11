<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios' 
import domainService from '@/services/domainService'


const domains = ref([])
const isLoading = ref(false)
const totalDomains = ref(0)
const searchQuery = ref('')
const selectedDomain = ref(null)
const isAddEditDomainDialogVisible = ref(false)
const isDeleteDialogVisible = ref(false)
const editMode = ref(false)
const sortBy = ref({ key: 'created_at', order: 'desc' })

const domainForm = ref({
  label: '',
  description: '',
  is_active: false,
})
const formErrors = ref({})
const isSubmitting = ref(false)

const currentPage = ref(1)
const pageSize = ref(10)
const pageSizeOptions = [5, 10, 15, 20]

const fileInput = ref(null)
const iconFile = ref(null)
const iconPreview = ref(null)
const uploadingIcon = ref(false)


const fetchDomains = async () => {
  isLoading.value = true
  try {
    const params = {
      page: currentPage.value,
      per_page: pageSize.value,
      search: searchQuery.value,
      sort_by: sortBy.value.key,
      sort_order: sortBy.value.order,
    };

    console.log('Fetching domains with params:', params);
    const response = await domainService.getDomains(params);
    console.log('API Response:', response);
    
    if (Array.isArray(response)) {
      domains.value = response;
      totalDomains.value = response.length;
    } else if (response && typeof response === 'object') {
      domains.value = response.data || [];
      totalDomains.value = response.total || response.meta?.total || 0;
    } else {
      domains.value = [];
      totalDomains.value = 0;
    }

    console.log('Domains after assignment:', domains.value);
  } catch (error) {
    console.error('Error fetching domains:', error);
    domains.value = [];
    totalDomains.value = 0;
  } finally {
    isLoading.value = false;
  }
}

onMounted(fetchDomains)

const resetForm = () => {
  domainForm.value = {
    label: '',
    description: '',
    is_active: false,
  }
  formErrors.value = {}
  editMode.value = false
  iconFile.value = null
  iconPreview.value = null
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

const addNewDomain = () => {
  resetForm()
  isAddEditDomainDialogVisible.value = true
}

const editDomain = (domain) => {
  domainForm.value = {
    label: domain.label,
    description: domain.description || '',
    is_active: Boolean(domain.is_active),
  }
  selectedDomain.value = domain
  editMode.value = true
  
  if (domain.icon) {
    iconPreview.value = null 
    setTimeout(() => {
      iconPreview.value = `http://127.0.0.1:8000${domain.icon}`
    }, 100)
  } else {
    iconPreview.value = null
  }

  isAddEditDomainDialogVisible.value = true
}

const submitDomainForm = async () => {
  formErrors.value = {}
  isSubmitting.value = true
  
  try {
    const formData = new FormData()
    formData.append('label', domainForm.value.label)
    formData.append('description', domainForm.value.description || '')
    formData.append('is_active', domainForm.value.is_active ? 1 : 0)

    if (iconFile.value) {
      formData.append('icon', iconFile.value)
    }
    
    if (editMode.value) {
      await domainService.updateDomain(selectedDomain.value.id, formData)
    } else {
      await domainService.createDomain(formData)
    }
    
    isAddEditDomainDialogVisible.value = false
    fetchDomains()
  } catch (error) {
    console.error('Error saving domain:', error)

    let payload = null
    const res = error?.response
    try {
      if (res && typeof res.json === 'function') {
        payload = await res.json()
      } else {
        payload = res?.data ?? error?.data ?? null
      }
    } catch (e) {
      payload = res?.data ?? error?.data ?? null
    }

    if (payload?.errors) {
      formErrors.value = payload.errors
    } else if (payload?.message) {
      formErrors.value = { general: payload.message }
    } else {
      formErrors.value = { general: 'An error occurred while saving the domain' }
    }
  } finally {
    isSubmitting.value = false
  }
}


const uploadIcon = () => {
  fileInput.value.click()
}

const handleFileChange = (event) => {
  const file = event.target.files[0]
  if (!file) return
  
  if (file.size > 800 * 1024) {
    formErrors.value = { icon: 'File size should be less than 800KB' }
    return
  }
  
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif']
  if (!allowedTypes.includes(file.type)) {
    formErrors.value = { icon: 'Only JPG, PNG and GIF files are allowed' }
    return
  }
  
  iconFile.value = file
  const reader = new FileReader()
  reader.onload = (e) => {
    iconPreview.value = e.target.result
  }
  reader.readAsDataURL(file)
}

const removeIcon = () => {
  iconFile.value = null
  iconPreview.value = null
  if (fileInput.value) {
    fileInput.value.value = '' 
  }
}

const deleteIcon = async () => {
  if (!editMode.value || !selectedDomain.value?.id) return
  
  try {
    uploadingIcon.value = true
    await domainService.removeIcon(selectedDomain.value.id)
    iconPreview.value = null
    
    selectedDomain.value.icon = null
    
    iconFile.value = null
    
    if (fileInput.value) {
      fileInput.value.value = ''
    }
  } catch (error) {
    console.error('Error removing icon:', error)
    formErrors.value = { icon: 'Failed to remove icon' }
  } finally {
    uploadingIcon.value = false
  }
}


const confirmDelete = (domain) => {
  selectedDomain.value = domain
  isDeleteDialogVisible.value = true
}

const deleteDomain = async () => {
  isSubmitting.value = true
  
  try {
    await domainService.deleteDomain(selectedDomain.value.id)
    fetchDomains()
    isDeleteDialogVisible.value = false
  } catch (error) {
    if (error.response?.status === 409) {
      alert(error.response.data.message)
    } else {
      console.error('Error deleting domain:', error)
    }
  } finally {
    isSubmitting.value = false
  }
}


const onPageChange = page => {
  currentPage.value = page
  fetchDomains()
}

const onPageSizeChange = size => {
  pageSize.value = size
  currentPage.value = 1
  fetchDomains()
}

const handleSearch = () => {
  currentPage.value = 1
  fetchDomains()
}

const sort = (key) => {
  if (sortBy.value.key === key) {
    sortBy.value.order = sortBy.value.order === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value.key = key
    sortBy.value.order = 'asc'
  }
  fetchDomains()
}

const isDomainInUse = (domain) => {
  return domain.clients_count > 0
}

</script>

<template>
  <VCard color="transparent" elevation="0">
    <!-- Header -->
    <VCardItem>
      <VCardTitle>Domain D'activité</VCardTitle>
      
      <template #append>
        <div class="d-flex align-center gap-4">
          <!-- Add New Button -->
          <VBtn
            prepend-icon="tabler-plus"
            @click="addNewDomain"
            color="primary"
          >
            Add New Domain
          </VBtn>
        </div>
      </template>
    </VCardItem>


    <!-- Table -->
    <VRow v-if="!isLoading" class="px-3 pt-3 mb-5">
      <VCol 
        v-for="item in (domains || [])" 
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
                <VImg 
                  v-if="item.icon" 
                  :src="`http://127.0.0.1:8000${item.icon}`"
                  @error="(e) => e.target.src = ''"
                />
                <span v-else>{{ item.label.charAt(0).toUpperCase() }}</span>
              </VAvatar>
            </template>
            
            <VCardTitle>
              {{ item.label }}
            </VCardTitle>


            <template #append>
              <VChip
                :color="item.is_active ? 'success' : 'secondary'"
                size="small"
                class="text-capitalize"
              >
                {{ item.is_active ? 'Active' : 'Inactive' }}
              </VChip>
            </template>
            
           
          </VCardItem>
          
          <VCardText class="pb-2">
            <div class="d-flex align-center justify-space-between mt-2">
              <p class="text-body-2 mb-2">
                {{ item.description || 'No description provided' }}
              </p>

              <span class="text-caption text-medium-emphasis">
                <VIcon icon="tabler-building" size="16" />
                  Used by {{ item.clients_count }} 
              </span>

            </div>
            
            <div class="d-flex align-center justify-space-between mt-2">
              <span class="text-caption text-medium-emphasis">
                ID: #{{ item.id }}
              </span>
              
              <span class="text-caption text-medium-emphasis">
                Created: {{ new Date(item.created_at).toLocaleDateString() }}
              </span>
            </div>
          </VCardText>
          
          <VDivider />
          
          <VCardActions>
            <VSpacer />
            <VBtn
              variant="text"
              size="small"
              color="primary"
              @click="editDomain(item)"
            >
              <VIcon icon="tabler-edit" class="me-1" size="16" />
              Edit
            </VBtn>
            
            <VBtn
              v-if="!isDomainInUse(item)"
              variant="text"
              size="small"
              color="error"
              @click="confirmDelete(item)"
            >
              <VIcon icon="tabler-trash" class="me-1" size="16" />
              Delete
            </VBtn>
            
            <VTooltip
              v-else
              location="top"
            >
              <span>Cannot delete: domain is being used by {{ item.clients_count }}</span>
            </VTooltip>
          </VCardActions>
        </VCard>
      </VCol>
    </VRow>

    <!-- Loading State -->
    <VRow v-else class="pa-3">
      <VCol v-for="n in 8" :key="n" cols="12" md="6" lg="4" xl="3">
        <VCard class="h-100">
          <VCardItem>
            <VSkeleton type="avatar" class="me-3" />
            <VSkeleton type="text" width="70%" />
          </VCardItem>
          <VCardText>
            <VSkeleton type="text" class="mb-2" />
            <VSkeleton type="text" width="40%" />
          </VCardText>
          <VCardActions>
            <VSkeleton type="button" width="80px" class="ms-auto me-2" />
            <VSkeleton type="button" width="80px" />
          </VCardActions>
        </VCard>
      </VCol>
    </VRow>

    <!-- Empty State -->
    <VRow v-if="!isLoading && (!domains || domains.length === 0)">
      <VCol cols="12">
        <VCard class="text-center py-8">
          <VIcon
            size="60"
            icon="tabler-mood-empty"
            class="text-medium-emphasis mb-4"
          />
          <h5 class="text-h6 text-medium-emphasis">No domains found</h5>
          <p class="text-body-1 text-medium-emphasis mb-6">
            Try adjusting your search or add a new domain
          </p>
          <VBtn
            prepend-icon="tabler-plus"
            @click="addNewDomain"
            color="primary"
          >
            Add New Domain
          </VBtn>
        </VCard>
      </VCol>
    </VRow>
    
    <!-- Pagination -->
    <div v-if="totalDomains > pageSize" class="d-flex align-center justify-space-between px-6 py-4">
      <div>
        <span class="text-body-2 text-medium-emphasis">
          Showing {{ (currentPage - 1) * pageSize + 1 }} to {{ Math.min(currentPage * pageSize, totalDomains) }} of {{ totalDomains }} entries
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
        :length="Math.ceil(totalDomains / pageSize)"
        :total-visible="5"
        @update:modelValue="onPageChange"
      />
    </div>
  </VCard>
  
  <VDialog
    v-model="isAddEditDomainDialogVisible"
    max-width="600px"
    persistent
  >
    <VCard>
      <VCardTitle class="d-flex justify-space-between align-center pa-4">
        {{ editMode ? 'Edit Domain' : 'Add New Domain' }}

        <VBtn
          icon
          variant="text"
          color="default"
          @click="isAddEditDomainDialogVisible = false"
        >
          <VIcon size="24" icon="tabler-x" />
        </VBtn>
      </VCardTitle>
      
      <VDivider />
      
      <VCardText class="pa-4">
        <VAlert
          v-if="formErrors.general"
          type="error"
          variant="tonal"
          closable
          class="mb-4"
        >
          {{ formErrors.general }}
        </VAlert>

        <VForm @submit.prevent="submitDomainForm">
          <VRow>
            <!-- Icon Upload -->
            <VCol cols="12">
              <p class="text-body-1 font-weight-medium mb-2">Domain Icon</p>
              
              <div class="d-flex align-center gap-4">
                <VAvatar size="80" rounded="rounded" class="bg-light-primary">
                  <VImg 
                    v-if="iconPreview" 
                    :src="iconPreview"
                    @error="(e) => e.target.src = ''"
                  />
                  <VImg 
                    v-else-if="editMode && selectedDomain?.icon" 
                    :src="`http://127.0.0.1:8000${selectedDomain.icon}`"
                    @error="(e) => e.target.src = ''"
                  />
                  <VIcon v-else icon="tabler-world" size="40" />
                </VAvatar>
                
                <div>
                  <!-- Hidden file input -->
                  <input
                    ref="fileInput"
                    type="file"
                    class="d-none"
                    accept="image/jpeg,image/png,image/gif"
                    @change="handleFileChange"
                  />
                  
                  <!-- Upload button -->
                  <VBtn
                    color="primary"
                    variant="tonal"
                    prepend-icon="tabler-upload"
                    class="mb-1"
                    @click="uploadIcon"
                    :disabled="uploadingIcon"
                  >
                    Upload Icon
                  </VBtn>
                  
                  <!-- Remove button - fixed condition -->
                  <VBtn
                    v-if="iconPreview || (editMode && selectedDomain?.icon)"
                    variant="outlined"
                    color="error"
                    class="ms-2 mb-1"
                    @click="editMode && selectedDomain?.icon ? deleteIcon() : removeIcon()"
                    :loading="uploadingIcon"
                  >
                    Remove
                  </VBtn>
                  
                  <div class="text-caption mt-1">
                    Allowed JPG, GIF or PNG. Max size of 800K
                  </div>
                  
                  <!-- Icon Error -->
                  <div v-if="formErrors.icon" class="text-error text-caption mt-1">
                    {{ formErrors.icon }}
                  </div>
                </div>
              </div>
            </VCol>
            
            <!-- Label Field -->
            <VCol cols="12">
              <VTextField
                v-model="domainForm.label"
                label="Domain Name"
                :error-messages="formErrors.label"
                required
                autofocus
              />
            </VCol>
            
            <!-- Description Field -->
            <VCol cols="12">
              <VTextarea
                v-model="domainForm.description"
                label="Description"
                :error-messages="formErrors.description"
                rows="3"
              />
            </VCol>
            
            <!-- Status Field -->
            <VCol cols="12">
              <VSwitch
                v-model="domainForm.is_active"
                label="Active"
                color="primary"
                :error-messages="formErrors.is_active"
                inset
              />
            </VCol>
            
          </VRow>
          
          <!-- Form Actions -->
          <div class="d-flex justify-end gap-3 mt-3">
            <VBtn
              variant="outlined"
              color="secondary"
              @click="isAddEditDomainDialogVisible = false"
              :disabled="isSubmitting"
            >
              Cancel
            </VBtn>
            
            <VBtn
              color="primary"
              :loading="isSubmitting"
              type="submit"
            >
              {{ editMode ? 'Update' : 'Create' }}
            </VBtn>
          </div>
        </VForm>
      </VCardText>
    </VCard>
  </VDialog>
  
  <!-- Delete Confirmation Dialog -->
  <VDialog
    v-model="isDeleteDialogVisible"
    max-width="500"
  >
    <VCard>
      <VCardTitle class="text-h5">Delete Domain</VCardTitle>
      
      <VCardText>
        Are you sure you want to delete the domain <strong>{{ selectedDomain?.label }}</strong>?<br>
        This action cannot be undone.
      </VCardText>
      
      <VCardActions>
        <VSpacer />
        
        <VBtn
          color="secondary"
          variant="text"
          @click="isDeleteDialogVisible = false"
          :disabled="isSubmitting"
        >
          Cancel
        </VBtn>
        
        <VBtn
          color="error"
          variant="elevated"
          :loading="isSubmitting"
          @click="deleteDomain"
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
.v-img__img--cover{
  object-fit: fill;
}
</style>
