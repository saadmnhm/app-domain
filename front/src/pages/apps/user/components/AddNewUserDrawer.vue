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
  isDrawerOpen: boolean 
}

const props = defineProps<Props>()
const emit = defineEmits<Emit>()

const isFormValid = ref(false)
const refForm = ref<VForm>()
const first_name = ref('')
const last_name = ref('')
const email = ref('')
const phone = ref('')
const password = ref('')
const confirm_password = ref('')
const role = ref()

const isSubmitting = ref(false)
const errorMessage = ref('')

const closeModal = () => {
  emit('update:isDrawerOpen', false)
  errorMessage.value = ''

  nextTick(() => {
    refForm.value?.reset()
    refForm.value?.resetValidation()
  })
}

const avatar = ref(null)
const avatarPreview = ref('')
const fileInput = ref<HTMLInputElement | null>(null)

const requiredValidator = (v: any) => !!v || 'This field is required'
const emailValidator = (v: any) => /.+@.+\..+/.test(v) || 'E-mail must be valid'
const uploadAvatar = () => {
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
  
  const validTypes = ['image/jpeg', 'image/png', 'image/gif'];
  if (!validTypes.includes(file.type)) {
    errorMessage.value = 'Only JPG, PNG, and GIF files are allowed';
    return;
  }
  
  avatar.value = file;
  avatarPreview.value = URL.createObjectURL(file);
  
  console.log('File selected:', file.name, 'Size:', Math.round(file.size/1024), 'KB');
}

const onSubmit = async () => {
  errorMessage.value = ''

  let valid = true
  try {
    const res = await refForm.value?.validate()
    valid = (res && typeof res === 'object' && 'valid' in res) ? res.valid : !!res
  } catch (e) {
    valid = false
  }

  if (!valid) return

  if (password.value) {
    if (String(password.value).length < 8) {
      errorMessage.value = 'Password must be at least 8 characters'
      return
    }
    if (password.value !== confirm_password.value) {
      errorMessage.value = 'Passwords do not match'
      return
    }
  }

  if (phone.value) {
    const phoneRegex = /^[0-9]+$/;

    if (!phoneRegex.test(phone.value)) {
      errorMessage.value = 'Phone must contain only numbers';
      return;
    }
  }

  isSubmitting.value = true

  try {
    const formData = new FormData()

    formData.append('first_name', first_name.value)
    formData.append('last_name', last_name.value)
    formData.append('email', email.value)
    
    if (phone.value) {
      formData.append('phone', String(phone.value))
    }

    if (password.value) {
      formData.append('password', String(password.value))
    }

    const roleValue = role.value && (typeof role.value === 'object' ? role.value.value ?? role.value : role.value)
    formData.append('role', roleValue || 'user')

    formData.append('is_active', '0')

    if (avatar.value instanceof File) {
      formData.append('avatar', avatar.value)
    }

    console.log('Submitting new user data')
    const response = await userService.createUser(formData)
    const created = response?.data?.user ?? response?.data ?? response
    console.log('User created response:', created)
    emit('userData', created)
    emit('refresh')
    emit('update:isDrawerOpen', false)

    first_name.value = ''
    last_name.value = ''
    email.value = ''
    phone.value = ''
    password.value = ''
    confirm_password.value = ''
    role.value = null
    avatar.value = null
    avatarPreview.value = ''
    if (fileInput.value) fileInput.value.value = ''

    nextTick(() => {
      refForm.value?.reset()
      refForm.value?.resetValidation()
    })
  } catch (error: any) {
    console.error('Create user error:', error?.response ?? error)

    const payload = error?.response?.data ?? error?.data ?? null

    if (payload?.errors) {
      const errorMessages = Object.values(payload.errors).flat()
      errorMessage.value = errorMessages.join(', ')
    } else if (payload?.message) {
      errorMessage.value = payload.message
    } else if (error?.message) {
      errorMessage.value = error.message
    } else {
      errorMessage.value = 'Failed to create user. Please try again.'
    }
  } finally {
    isSubmitting.value = false
    
  }
}

const roleOptions = [
  { title: 'Admin', value: 'admin' },
  { title: 'Manager', value: 'manager' },
]

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
            <!-- Role -->
            <VCol cols="12">
              <AppSelect
                v-model="role"
                :items="roleOptions"
                label="Role"
                placeholder="Select Role"
                :rules="[requiredValidator]"
              />
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
              />
            </VCol>
            <!-- Password -->
             <VCol cols="6">
              <AppTextField
                v-model="password"
                label="Password"
                type="password"
                placeholder="Enter password"
              />
            </VCol>
              <!-- Confirm Password -->
             <VCol cols="6">
              <AppTextField
                v-model="confirm_password"
                label="Confirm Password"
                type="password"
                placeholder="Enter password"
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
