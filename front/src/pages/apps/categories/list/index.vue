<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import categoryService from '@/services/categoryService'

const is_used = ref(false)

const categories = ref([])
const isLoading = ref(false)
const totalCategories = ref(0)
const searchQuery = ref('')
const selectedCategory = ref(null)
const isAddEditCategoryDialogVisible = ref(false)
const isDeleteDialogVisible = ref(false)
const editMode = ref(false)
const sortBy = ref({ key: 'created_at', order: 'desc' })

const categoryForm = ref({
  label: '',
  description: '',
  is_active: false,
})
const formErrors = ref({})
const isSubmitting = ref(false)

const currentPage = ref(1)
const pageSize = ref(10)

const fileInput = ref(null)
const iconFile = ref(null)
const iconPreview = ref(null)
const uploadingIcon = ref(false)


const fetchCategories = async () => {
  isLoading.value = true
  try {
    const params = {
      page: currentPage.value,
      per_page: pageSize.value,
      search: searchQuery.value,
      sort_by: sortBy.value.key,
      sort_order: sortBy.value.order,
    };

    console.log('Fetching categories with params:', params);
    const response = await categoryService.getCategories(params);
    console.log('API Response:', response);
    
    if (Array.isArray(response)) {
      categories.value = response;
      totalCategories.value = response.length;
    } else if (response && typeof response === 'object') {
      categories.value = response.data || [];
      totalCategories.value = response.total || response.meta?.total || 0;
    } else {
      categories.value = [];
      totalCategories.value = 0;
    }

    console.log('Categories after assignment:', categories.value);
  } catch (error) {
    console.error('Error fetching categories:', error);
    categories.value = [];
    totalCategories.value = 0;
  } finally {
    isLoading.value = false;
  }
}

onMounted(fetchCategories)

const resetForm = () => {
  categoryForm.value = {
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

const addNewCategory = () => {
  resetForm()
  isAddEditCategoryDialogVisible.value = true
}

const editCategory = (category) => {
  categoryForm.value = {
    label: category.label,
    description: category.description || '',
    is_active: Boolean(category.is_active),
  }
  selectedCategory.value = category
  editMode.value = true
  
  if (category.icon) {
    iconPreview.value = null 
    setTimeout(() => {
      iconPreview.value = category.icon.startsWith('http') 
        ? category.icon 
        : `http://127.0.0.1:8000${category.icon}`
    }, 50)
  } else {
    iconPreview.value = null
  }
  
  isAddEditCategoryDialogVisible.value = true
}

const submitCategoryForm = async () => {
  formErrors.value = {}
  isSubmitting.value = true
  
  try {
    let payload;
    let response;
    
    if (editMode.value) {
      if (iconFile.value) {
        const formData = new FormData()
        formData.append('label', categoryForm.value.label)
        formData.append('description', categoryForm.value.description || '')
        formData.append('is_active', categoryForm.value.is_active ? 1 : 0)
        formData.append('icon', iconFile.value)
        formData.append('_method', 'PUT') 
        
        response = await axios.post(
          `${import.meta.env.VITE_APP_API_URL || 'http://localhost:8000/api'}/categories/${selectedCategory.value.id}`, 
          formData
        );
      } else {
        payload = {
          label: categoryForm.value.label,
          description: categoryForm.value.description || '',
          is_active: categoryForm.value.is_active ? 1 : 0,
        };
        
        response = await categoryService.updateCategory(selectedCategory.value.id, payload);
      }
    } else {
      const formData = new FormData()
      formData.append('label', categoryForm.value.label)
      formData.append('description', categoryForm.value.description || '')
      formData.append('is_active', categoryForm.value.is_active ? 1 : 0)
      
      if (iconFile.value) {
        formData.append('icon', iconFile.value)
      }
      
      response = await categoryService.createCategory(formData)
    }
    
    isAddEditCategoryDialogVisible.value = false
    fetchCategories()
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
  if (!editMode.value || !selectedCategory.value?.id) return
  
  try {
    uploadingIcon.value = true
    await categoryService.removeIcon(selectedCategory.value.id)
    
    selectedCategory.value.icon = null
    iconPreview.value = null
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


const confirmDelete = (category) => {
  selectedCategory.value = category
  isDeleteDialogVisible.value = true
}

const deleteCategory = async () => {
  isSubmitting.value = true
  
  try {
    await categoryService.deleteCategory(selectedCategory.value.id)
    fetchCategories()
    isDeleteDialogVisible.value = false
  } catch (error) {
    if (error.response?.status === 409) {
      alert(error.response.message)
    } else {
      console.error('Error deleting category:', error)
    }
  } finally {
    isSubmitting.value = false
  }
}


const onPageChange = page => {
  currentPage.value = page
  fetchCategories()
}

const onPageSizeChange = size => {
  pageSize.value = size
  currentPage.value = 1
  fetchCategories()
}

const handleSearch = () => {
  currentPage.value = 1
  fetchCategories()
}

const sort = (key) => {
  if (sortBy.value.key === key) {
    sortBy.value.order = sortBy.value.order === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value.key = key
    sortBy.value.order = 'asc'
  }
  fetchCategories()
}


const isCategoryInUse = (category) => {
  return category.clients_count > 0
}

</script>

<template>
  <VCard color="transparent" elevation="0">
    <!-- Header -->
    <VCardItem>
      <VCardTitle>Client Categories</VCardTitle>
      
      <template #append>
        <div class="d-flex align-center gap-4">
          <!-- Add New Button -->
          <VBtn
            prepend-icon="tabler-plus"
            @click="addNewCategory"
            color="primary"
          >
            Add New Category
          </VBtn>
        </div>
      </template>
    </VCardItem>


    <!-- Table -->
    <VRow v-if="!isLoading" class="px-3 pt-3 mb-5" style="background-color: transparent;">
      <VCol 
        v-for="item in (categories || [])" 
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
              @click="editCategory(item)"
            >
              <VIcon icon="tabler-edit" class="me-1" size="16" />
              Edit
            </VBtn>
            
            <!-- Only show delete button if category is NOT in use -->
            <VBtn
              v-if="!isCategoryInUse(item)"
              variant="text"
              size="small"
              color="error"
              @click="confirmDelete(item)"
            >
              <VIcon icon="tabler-trash" class="me-1" size="16" />
              Delete
            </VBtn>
            
            <!-- Show disabled button with tooltip if category IS in use -->
            <VTooltip
              v-else
              location="top"
            >
              <template #activator="{ props }">
                
              </template>
              <span>Cannot delete: Category is being used by {{ item.clients_count }} client{{ item.clients_count !== 1 ? 's' : '' }}</span>
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
    <VRow v-if="!isLoading && (!categories || categories.length === 0)">
      <VCol cols="12">
        <VCard class="text-center py-8">
          <VIcon
            size="60"
            icon="tabler-mood-empty"
            class="text-medium-emphasis mb-4"
          />
          <h5 class="text-h6 text-medium-emphasis">No categories found</h5>
          <p class="text-body-1 text-medium-emphasis mb-6">
            Try adjusting your search or add a new category
          </p>
          <VBtn
            prepend-icon="tabler-plus"
            @click="addNewCategory"
            color="primary"
          >
            Add New Category
          </VBtn>
        </VCard>
      </VCol>
    </VRow>
    
    <!-- Pagination -->
    
  </VCard>
  
  <VDialog
    v-model="isAddEditCategoryDialogVisible"
    max-width="600px"
    persistent
  >
    <VCard>
      <VCardTitle class="d-flex justify-space-between align-center pa-4">
        {{ editMode ? 'Edit Category' : 'Add New Category' }}
        
        <VBtn
          icon
          variant="text"
          color="default"
          @click="isAddEditCategoryDialogVisible = false"
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

        <VForm @submit.prevent="submitCategoryForm">
          <VRow>
            <!-- Icon Upload -->
            <VCol cols="12">
              <p class="text-body-1 font-weight-medium mb-2">Category Icon</p>
              
              <div class="d-flex align-center gap-4">
                <VAvatar size="80" rounded="rounded" class="bg-light-primary">
                  <VImg 
                    v-if="iconPreview" 
                    :src="iconPreview"
                    @error="(e) => e.target.src = ''"
                  />
                  <VImg 
                    v-else-if="editMode && selectedCategory?.icon" 
                    :src="`http://127.0.0.1:8000${selectedCategory.icon}`"
                    @error="(e) => e.target.src = ''"
                  />
                  <VIcon v-else icon="tabler-category" size="40" />
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
                  
                  <!-- Remove button -->
                  <VBtn
                    v-if="iconPreview"
                    variant="outlined"
                    color="error"
                    class="ms-2 mb-1"
                    @click="editMode && selectedCategory?.icon ? deleteIcon() : removeIcon()"
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
                v-model="categoryForm.label"
                label="Category Name"
                :error-messages="formErrors.label"
                required
                autofocus
              />
            </VCol>
            
            <!-- Description Field -->
            <VCol cols="12">
              <VTextarea
                v-model="categoryForm.description"
                label="Description"
                :error-messages="formErrors.description"
                rows="3"
              />
            </VCol>
            
            <!-- Status Field -->
            <VCol cols="12">
              <VSwitch
                v-model="categoryForm.is_active"
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
              @click="isAddEditCategoryDialogVisible = false"
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
      <VCardTitle class="text-h5">Delete Category</VCardTitle>
      
      <VCardText>
        Are you sure you want to delete the category <strong>{{ selectedCategory?.label }}</strong>?<br>
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
          @click="deleteCategory"
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
