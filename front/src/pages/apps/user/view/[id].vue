<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/authStore' 
import userService from '@/services/userService'

const authStore = useAuthStore()
const currentUserId = authStore.user?.id

const route = useRoute()
const userId = route.params.id
const router = useRouter() 

const goBack = () => {
  router.back()
}

const isLoading = ref(true)
const form = ref(null)
const isSubmitting = ref(false)
const alertMessage = ref('')
const alertType = ref('success')

const userData = reactive({
  first_name: '',
  last_name: '',
  email: '',
  role: '',
  is_active: '',
  avatar: ''
})

const passwordData = reactive({
  newPassword: '',
  confirmPassword: ''
})

const roleOptions = [
  { title: 'Admin', value: 'admin' },
  { title: 'Manager', value: 'manager' },
]

const fileInput = ref<HTMLInputElement | null>(null);

onMounted(async () => {
  try {
    isLoading.value = true
    const response = await userService.getUser(Number(userId))
    
    Object.assign(userData, response)
    
  } catch (error) {
    console.error('Error fetching user data:', error)
    alertMessage.value = 'Failed to load user information'
    alertType.value = 'error'
  } finally {
    isLoading.value = false
  }
})

const uploadAvatar = () => {
  fileInput.value?.click();
}

const handleFileChange = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (!target.files || target.files.length === 0) return;
  
  const file = target.files[0];
  if (!file) return;
  
  if (file.size > 800 * 1024) {
    alertMessage.value = 'File size exceeds 800KB limit';
    alertType.value = 'error';
    return;
  }
  
  const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
  if (!validTypes.includes(file.type)) {
    alertMessage.value = 'Only JPG, PNG, and GIF files are allowed';
    alertType.value = 'error';
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    const formData = new FormData();
    formData.append('avatar', file);
    
    const response = await userService.uploadAvatar(Number(userId), formData);
    
    userData.avatar = response.avatar;
    
    alertMessage.value = 'Avatar uploaded successfully';
    alertType.value = 'success';
  } catch (error) {
    console.error('Error uploading avatar:', error);
    alertMessage.value = 'Failed to upload avatar';
    alertType.value = 'error';
  } finally {
    isSubmitting.value = false;
    if (fileInput.value) fileInput.value.value = '';
  }
}

const removeAvatar = async () => {
  if (!userData.avatar) {
    alertMessage.value = 'No avatar to remove';
    alertType.value = 'info';
    return;
  }
  
  isSubmitting.value = true;
  
  try {
    await userService.removeAvatar(Number(userId));
    
    userData.avatar = '';
    
    alertMessage.value = 'Avatar removed successfully';
    alertType.value = 'success';
  } catch (error) {
    console.error('Error removing avatar:', error);
    alertMessage.value = 'Failed to remove avatar';
    alertType.value = 'error';
  } finally {
    isSubmitting.value = false;
  }
}

const saveUserInfo = async () => {
  const { valid } = await form.value.validate()
  
  if (!valid) return
  
  isSubmitting.value = true
  
  try {
    console.log('Sending data to API:', userData)
    const response = await userService.updateUser(Number(userId), userData)
    console.log('API response:', response)
    
    if (passwordData.newPassword) {
      if (passwordData.newPassword !== passwordData.confirmPassword) {
        throw new Error('Passwords do not match')
      }
      if (passwordData.newPassword.length < 8) {
        throw new Error('Password must be at least 8 characters')
      }
      
      await userService.updateUserPassword(Number(userId), {
        newPassword: passwordData.newPassword
      })
    }
    
    alertMessage.value = 'User information updated successfully'
    alertType.value = 'success'
    
    passwordData.newPassword = ''
    passwordData.confirmPassword = ''
  } catch (error) {
    alertMessage.value = error.message || 'Error updating user information'
    alertType.value = 'error'
  } finally {
    isSubmitting.value = false
  }
}


const toggleSuspend = async () => {
  isSubmitting.value = true
  try {
    const response = await userService.toggleUserStatus(Number(userId))
    userData.is_active = response.is_active
    alertMessage.value = `User has been ${userData.is_active ? 'activated' : 'suspended'} successfully`
    alertType.value = 'success'
  } catch (error) {
    console.error('Error toggling user status:', error)
    alertMessage.value = 'Failed to toggle user status'
    alertType.value = 'error'
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <VRow>
    <!-- Left Column - User Info Cards -->
    <VCol cols="12" md="5" lg="4">
      <!-- User Info Card -->
      <VCard class="mb-6">
        <VCardText class="text-center pt-12">
          <!-- User Avatar -->
          <VAvatar size="200" rounded="rounded" variant="flat">
            <VImg :src="`http://127.0.0.1:8000${userData.avatar}`">
              <template v-slot:placeholder>
                <VIcon icon="tabler-user" size="50" />
              </template>
              <template v-slot:error>
                <VIcon icon="tabler-user" size="50" />
              </template>
            </VImg>
          </VAvatar>

          <h5 class="text-h5 mt-4">{{ userData.first_name }} {{ userData.last_name }}</h5>

          <!-- Role Badge -->
          <VChip
            color="secondary"
            variant="tonal"
            size="small"
            label
            class="text-capitalize mt-4"
          >
            {{ userData.role }}
          </VChip>
        </VCardText>

        <VCardText>
       
          <!-- User Details -->
          <h5 class="text-h5">Details</h5>
          <VDivider class="my-4" />
          
          <VList density="compact" class="card-list mt-2">
            <!-- First Name -->
            <VListItem>
              <VListItemTitle>
                <h6 class="text-h6">
                  First Name:
                  <div class="d-inline-block text-body-1">{{ userData.first_name }}</div>
                </h6>
              </VListItemTitle>
            </VListItem>
            <!-- Last Name -->
            <VListItem>
              <VListItemTitle>
                <h6 class="text-h6">
                  Last Name:
                  <div class="d-inline-block text-body-1">{{ userData.last_name }}</div>
                </h6>
              </VListItemTitle>
            </VListItem>
            <!-- Email -->
            <VListItem>
              <VListItemTitle>
                <span class="text-h6"> Email:</span>
                <span class="text-body-1">{{ userData.email }}</span>
              </VListItemTitle>
            </VListItem>
            
            <!-- Status -->
            <VListItem>
              <VListItemTitle>
                <h6 class="text-h6">
                  Status:
                  <VChip v-if="userData.is_active > 0" size="small" color="success" class=" d-inline-block text-body-1 text-capitalize">active</VChip>
                  <VChip v-else size="small" color="error" class="d-inline-block text-body-1 text-capitalize">inactive</VChip>
                </h6>
              </VListItemTitle>
            </VListItem>
            
            <!-- Role -->
            <VListItem>
              <VListItemTitle>
                <h6 class="text-h6">
                  Role:
                  <div class="d-inline-block text-capitalize text-body-1">{{ userData.role }}</div>
                </h6>
              </VListItemTitle>
            </VListItem>
            
            

            
            
           
          </VList>
        </VCardText>

        <!-- Action Buttons -->
          <VCardText class="d-flex justify-center gap-x-4">
            <template v-if="userId != currentUserId">
              <VBtn v-if="userData.is_active>0" variant="tonal" color="error" @click="toggleSuspend">
                Suspend
              </VBtn>
              <VBtn v-else variant="tonal" color="success" @click="toggleSuspend">
                Activate
              </VBtn>
            </template>
          </VCardText>
      </VCard>

    </VCol>
    
    <VCol cols="12" md="7" lg="8">
      <VCard>
        <VCardText class="d-flex justify-space-between align-center flex-wrap gap-4">
          <h5 class="text-h5">Edit User Information</h5>
          
         
        </VCardText>
        
                <VForm @submit.prevent="saveUserInfo" ref="form">
          <VCardText>
            <!-- Alert for success/error messages -->
            <VAlert
              v-if="alertMessage"
              :type="alertType"
              variant="tonal"
              class="mb-4"
              closable
              @click:close="alertMessage = ''"
            >
              {{ alertMessage }}
            </VAlert>

            <VRow>
              <!-- Personal Information Section -->
              <VCol cols="12">
                <h6 class="text-h6 mb-2">Personal Information</h6>
              </VCol>

              <!-- Full Name -->
              <VCol cols="12" md="6">
                <VTextField
                  v-model="userData.first_name"
                  label="First Name"
                  :rules="[(v) => !!v || 'Name is required']"
                  variant="outlined"
                  density="comfortable"
                />
              </VCol>

              <!-- Last Name -->
              <VCol cols="12" md="6">
                <VTextField
                  v-model="userData.last_name"
                  label="Last Name"
                  :rules="[(v) => !!v || 'Name is required']"
                  variant="outlined"
                  density="comfortable"
                />
              </VCol>

              <!-- Email -->
              <VCol cols="12" md="6">
                <VTextField
                  v-model="userData.email"
                  label="Email"
                  type="email"
                  :rules="[
                    (v) => !!v || 'Email is required',
                    (v) => /.+@.+\..+/.test(v) || 'E-mail must be valid'
                  ]"
                  placeholder="john@example.com"
                  variant="outlined"
                  density="comfortable"
                />
              </VCol>

              <!-- Phone -->
              <VCol cols="12" md="6">
                <VTextField
                  v-model="userData.phone"
                  label="Phone"
                  placeholder="(123) 456-7890"
                  variant="outlined"
                  density="comfortable"
                />
              </VCol>

              <!-- Role -->
              <VCol cols="12" md="6">
                <AppSelect
                  v-model="userData.role"
                  :items="roleOptions"
                  label="Role"
                  placeholder="Select Role"
                  :rules="[requiredValidator]"
                />
              </VCol>

            <!-- Avatar Section -->
            <VCol cols="12">
              <h6 class="text-h6 mb-2 mt-4">Profile Image</h6>
            </VCol>

            <VCol cols="12">
              <div class="d-flex align-center gap-4">
                <VAvatar size="80" rounded="rounded" class="me-4">
                  <VImg :src="userData.avatar"></VImg>
                </VAvatar>
                <div>
                  <VBtn
                    color="primary"
                    prepend-icon="tabler-upload"
                    variant="tonal"
                    @click="uploadAvatar"
                  >
                    Upload New Photo
                  </VBtn>
                  <VBtn
                    variant="outlined"
                    color="error"
                    class="ms-4"
                    @click="removeAvatar"
                  >
                    Remove
                  </VBtn>
                  <div class="text-caption mt-2">
                    Allowed JPG, GIF or PNG. Max size of 800K
                  </div>
                </div>
              </div>
            </VCol>

            <!-- Change Password Section -->
            <VCol cols="12">
              <h6 class="text-h6 mb-2 mt-4">Change Password</h6>
            </VCol>

          

            <!-- New Password -->
            <VCol cols="12" md="6">
              <VTextField
                v-model="userData.password"
                label="New Password"
                type="password"
                variant="outlined"
                density="comfortable"
                :rules="[v => !v || v.length >= 8 || 'Password must be at least 8 characters']"
                autocomplete="new-password"
              />
            </VCol>

          </VRow>
        </VCardText>

        <VDivider />

        <VCardActions class="px-6 py-3">
          <VSpacer />
          <VBtn
            variant="tonal"
            color="secondary"
            @click="goBack"
          >
            Cancel
          </VBtn>
          <VBtn
            color="primary"
            variant="elevated"
            type="submit"
            :loading="isSubmitting"
          >
            Save Changes
          </VBtn>
        </VCardActions>
      </VForm>
      </VCard>
    </VCol>
  </VRow>

  <!-- Hidden file input for avatar upload -->
  <input
    type="file"
    accept="image/*"
    ref="fileInput"
    style="display: none"
    @change="handleFileChange"
  />
</template>

<style scoped>
/* Add any component-specific styles here */
.card-list :deep(.v-list-item) {
  min-height: unset !important;
  padding-inline: 0;
}
</style>
