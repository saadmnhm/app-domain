<script setup lang="ts">
import { PerfectScrollbar } from 'vue3-perfect-scrollbar'
import type { VForm } from 'vuetify/components/VForm'
import type { UserProperties } from '@db/apps/users/types'
import userService from '@/services/userService'
import { ref, reactive, nextTick } from 'vue'

interface Emit {
  (e: 'update:isDrawerOpen', value: boolean): void
  (e: 'userData', value: UserProperties): void
  (e: 'refresh'): void
}

interface Props {
  isDrawerOpen: boolean // Changed from modelValue
}

const props = defineProps<Props>()
const emit = defineEmits<Emit>()

// Form state
const isFormValid = ref(false)
const refForm = ref<VForm>()
const first_name = ref('')
const last_name = ref('')
const email = ref('')
const phone = ref('')
const password = ref('')
const role = ref()
const status = ref()

// Add loading and error states
const isSubmitting = ref(false)
const errorMessage = ref('')

// Close modal
const closeModal = () => {
  emit('update:isDrawerOpen', false)
  errorMessage.value = ''

  nextTick(() => {
    refForm.value?.reset()
    refForm.value?.resetValidation()
  })
}

// Add these refs for avatar functionality after your existing refs
const avatar = ref(null)
const avatarPreview = ref('')
const fileInput = ref<HTMLInputElement | null>(null)

// Add these validation constants if not already defined
const requiredValidator = (v: any) => !!v || 'This field is required'
const emailValidator = (v: any) => /.+@.+\..+/.test(v) || 'E-mail must be valid'

// Handle avatar upload
const uploadAvatar = () => {
  // Trigger the hidden file input
  if (fileInput.value) fileInput.value.click();
}

const handleFileChange = (event) => {
  const target = event.target;
  if (!target.files || target.files.length === 0) return;
  
  const file = target.files[0];
  if (!file) return;
  
  if (file.size > 800 * 1024) {
    errorMessage.value = 'File size exceeds 800KB limit';
    return;
  }
  
  // Validate file type
  const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
  if (!validTypes.includes(file.type)) {
    errorMessage.value = 'Only JPG, PNG, and GIF files are allowed';
    return;
  }
  
  // Store the file and create a preview
  avatar.value = file;
  avatarPreview.value = URL.createObjectURL(file);
  
  console.log('File selected:', file.name, 'Size:', Math.round(file.size/1024), 'KB');
}

// Update your onSubmit function to include avatar
const onSubmit = async () => {
  errorMessage.value = '';
  
  refForm.value?.validate().then(async ({ valid }) => {
    if (valid) {
      isSubmitting.value = true;
      
      try {
        // Prepare form data for multipart/form-data
        const formData = new FormData();
        
        // Add text fields
        formData.append('first_name', first_name.value);
        formData.append('last_name', last_name.value);
        formData.append('email', email.value);
        formData.append('phone', phone.value || '');
        formData.append('password', password.value);
        formData.append('role', role.value);
        
        // Convert status to is_active
        const isActive = status.value === 'active' ? 1 : 0;
        formData.append('is_active', isActive.toString());
        
        // Add avatar if selected
        if (avatar.value instanceof File) {
          console.log('Adding avatar to form:', avatar.value.name);
          formData.append('avatar', avatar.value);
        }
        
        // Call your API service
        console.log('Submitting new user data with avatar:', !!avatar.value);
        const response = await userService.createUser(formData);
        console.log('User created response:', response.data);
        
        // Close modal and emit refresh event
        emit('refresh');
        emit('update:isDrawerOpen', false);
        
        // Reset form
        first_name.value = '';
        last_name.value = '';
        email.value = '';
        phone.value = '';
        password.value = '';
        role.value = null;
        status.value = null;
        avatar.value = null;
        avatarPreview.value = '';
        if (fileInput.value) fileInput.value.value = '';
        
        nextTick(() => {
          refForm.value?.reset();
          refForm.value?.resetValidation();
        });
      } catch (error) {
        console.error('Error creating user:', error);
        console.error('Response data:', error.response?.data);
        
        if (error.response?.data?.errors) {
          const errorMessages = Object.values(error.response.data.errors).flat();
          errorMessage.value = errorMessages.join(', ');
        } else {
          errorMessage.value = error.response?.data?.message || 'Failed to create user';
        }
      } finally {
        isSubmitting.value = false;
      }
    }
  });
}

const roleOptions = [
  { title: 'Admin', value: 'admin' },
  { title: 'Manager', value: 'manager' },
]
const statusOptions = [
  { title: 'Active', value: 'active' },
  { title: 'Inactive', value: 'inactive' },
]
// Add function to remove selected avatar
const removeAvatar = () => {
  avatar.value = null
  avatarPreview.value = ''
  if (fileInput.value) fileInput.value.value = ''
}
</script>

<template>
  <VDialog
    :model-value="props.isDrawerOpen"
    @update:model-value="emit('update:isDrawerOpen', $event)"
    max-width="700px"
    persistent
    class="v-dialog-l"
  >
    <VCard>
      <!-- Dialog Header -->
      <VCardTitle class="d-flex justify-space-between align-center pa-4">
        <span class="text-h5">Add New User</span>
        <VBtn
          icon
          variant="text"
          color="default"
          @click="closeModal"
        >
          <VIcon size="24">mdi-close</VIcon>
        </VBtn>
      </VCardTitle>

      <VDivider />

      <VCardText class="pa-4">
        <!-- Error Alert -->
        <VAlert
          v-if="errorMessage"
          type="error"
          variant="tonal"
          class="mb-4"
          closable
          @click:close="errorMessage = ''"
        >
          {{ errorMessage }}
        </VAlert>
        
        <!-- Form -->
        <VForm
          ref="refForm"
          v-model="isFormValid"
          @submit.prevent="onSubmit"
        >
          <VRow>
             <!-- Avatar Upload -->
            <VCol cols="12">
              <p class="text-body-1 font-weight-medium mb-2">Profile Image</p>
              
              <div class="d-flex align-center gap-4">
                <VAvatar size="80" rounded="rounded" class="bg-light-primary">
                  <VImg v-if="avatarPreview" :src="avatarPreview"></VImg>
                  <VIcon v-else icon="tabler-user" size="40"></VIcon>
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
                    @click="uploadAvatar"
                  >
                    Upload Avatar
                  </VBtn>
                  
                  <!-- Remove button (only show when avatar is selected) -->
                  <VBtn
                    v-if="avatarPreview"
                    variant="outlined"
                    color="error"
                    class="ms-2 mb-1"
                    @click="removeAvatar"
                  >
                    Remove
                  </VBtn>
                  
                  <div class="text-caption mt-1">
                    Allowed JPG, GIF or PNG. Max size of 800K
                  </div>
                </div>
              </div>
            </VCol>
            
            <!-- First Name -->
            <VCol cols="6">
              <AppTextField
                v-model="first_name"
                label="First Name"
                placeholder="John"
                :rules="[requiredValidator]"
              />
            </VCol>
            <!-- Last Name -->
            <VCol cols="6">
              <AppTextField
                v-model="last_name"
                label="Last Name"
                placeholder="Doe"
                :rules="[requiredValidator]"
              />
            </VCol>
            <!-- Email -->
            <VCol cols="6">
              <AppTextField
                v-model="email"
                label="Email"
                placeholder="johndoe@example.com"
                :rules="[requiredValidator, emailValidator]"
              />
            </VCol>
             <!-- Phone -->
            <VCol cols="6">
              <AppTextField
                v-model="phone"
                label="Phone"
                placeholder="+212 645-678901"
                :rules="[requiredValidator]"
              />
            </VCol>
            <!-- Password -->
             <VCol cols="6">
              <AppTextField
                v-model="password"
                label="Password"
                type="password"
                placeholder="Enter password"
                :rules="[requiredValidator]"
              />
            </VCol>
            <!-- Role -->
            <VCol cols="6">
              <AppSelect
                v-model="role"
                :items="roleOptions"
                label="Role"
                placeholder="Select Role"
                :rules="[requiredValidator]"
              />
            </VCol>

            <!-- Status -->
            <VCol cols="6">
              <AppSelect
                v-model="status"
                :items="statusOptions"
                label="Status"
                placeholder="Select Status"
                :rules="[requiredValidator]"
              />
            </VCol>

           
          </VRow>
        </VForm>
      </VCardText>

      <VDivider />

      <VCardActions class="pa-4">
        <VSpacer />
        <VBtn
          color="secondary"
          variant="text"
          @click="closeModal"
        >
          Cancel
        </VBtn>
        <VBtn
          color="primary"
          :loading="isSubmitting"
          @click="onSubmit"
        >
          Create User
        </VBtn>
      </VCardActions>
    </VCard>
  </VDialog>
</template>
