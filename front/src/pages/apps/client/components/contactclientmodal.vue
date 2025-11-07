<script setup>
import { ref, computed, defineProps, defineEmits, onMounted, defineExpose } from 'vue'
import clientContactService from '@/services/clientcontactService'

const props = defineProps({
  clientId: {
    type: [Number, String],
    required: true
  },
  contactData: {
    type: Object,
    default: () => ({})
  },
  isEditMode: {
    type: Boolean,
    default: false
  },
  hideActions: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['saved', 'canceled'])

const clientForm = ref({
  contact: {
    first_name: props.contactData?.first_name || '',
    last_name: props.contactData?.last_name || '',
    email: props.contactData?.email || '',
    phone: props.contactData?.phone || '',
    fonction: props.contactData?.fonction || '',
    is_responsable: props.contactData?.is_responsable !== undefined ? props.contactData.is_responsable : true,
    client_id: props.clientId,
    user_id: 1 
  }
})

const formErrors = ref({})
const isSubmitting = ref(false)
const editMode = computed(() => props.isEditMode)
const emailInputRef = ref(null)

const submitContactForm = async () => {
  formErrors.value = {}
  isSubmitting.value = true
  
  try {
    const contactData = { ...clientForm.value.contact }
    
    contactData.client_id = props.clientId
    
    let response
    
    if (editMode.value && props.contactData?.id) {
      response = await clientContactService.updateContact(
        props.contactData.id, 
        contactData
      )
    } else {
      response = await clientContactService.createContact(contactData)
    }
    
    emit('saved', response.data)
    return response
    
  } catch (error) {
    console.error('Error saving contact:', error)
    
    if (error.response?.data?.errors) {
      formErrors.value = error.response.data.errors
    } else if (error.response?.data?.message) {
      const errorMessage = error.response.data.message
      
      if (errorMessage.includes('Duplicate entry') && errorMessage.includes('email_unique')) {
        formErrors.value.email = ['This email address is already in use by another contact.']
        
        setTimeout(() => {
          if (emailInputRef.value) {
            emailInputRef.value.focus()
          }
        }, 100)
      } else {
        formErrors.value.general = error.response.data.message
      }
    } else {
      formErrors.value.general = 'An error occurred while saving. Please try again.'
    }
    throw error
  } finally {
    isSubmitting.value = false
  }
}

const submitForm = async (overrideClientId = null) => {
  if (overrideClientId) {
    clientForm.value.contact.client_id = overrideClientId
  }
  return await submitContactForm()
}

const cancelForm = () => {
  emit('canceled')
}

defineExpose({
  submitForm
})
</script>

<template>
  <VForm @submit.prevent="submitForm">
    <VRow>
      <!-- Add a general error message at the top -->
      <VCol v-if="formErrors.general" cols="12">
        <VAlert
          density="compact"
          type="error"
          variant="tonal"
          closable
        >
          {{ formErrors.general }}
        </VAlert>
      </VCol>

      <VCol cols="12" md="6">
        <VTextField
          v-model="clientForm.contact.first_name"
          label="First Name"
          :error-messages="formErrors.first_name"
          required
        />
      </VCol>

      <VCol cols="12" md="6">
        <VTextField
          v-model="clientForm.contact.last_name"
          label="Last Name"
          :error-messages="formErrors.last_name"
          required
        />
      </VCol>

      <VCol cols="12" md="6">
        <VTextField
          v-model="clientForm.contact.email"
          label="Email"
          type="email"
          :error-messages="formErrors.email"
          ref="emailInputRef"
          required
        />
      </VCol>

      <VCol cols="12" md="6">
        <VTextField
          v-model="clientForm.contact.phone"
          label="Phone"
          :error-messages="formErrors.phone"
        />
      </VCol>

      <VCol cols="12">
        <VTextField
          v-model="clientForm.contact.fonction"
          label="Function/Role"
          :error-messages="formErrors.fonction"
        />
      </VCol>

      <VCol cols="12">
        <VSwitch
          v-model="clientForm.contact.is_responsable"
          label="Is Primary Contact"
          color="primary"
          hide-details
        />
      </VCol>

      <VCol v-if="!props.hideActions" cols="12" class="d-flex gap-4 justify-end">
        <VBtn
          color="secondary"
          variant="tonal"
          @click="cancelForm"
          :disabled="isSubmitting"
        >
          Cancel
        </VBtn>
        
        <VBtn
          color="primary"
          type="submit"
          :loading="isSubmitting"
        >
          {{ editMode ? 'Update' : 'Save' }} Contact
        </VBtn>
      </VCol>
    </VRow>
  </VForm>
</template>
