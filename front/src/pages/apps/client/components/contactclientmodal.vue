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
    is_responsable: props.contactData?.is_responsable !== undefined ? props.contactData.is_responsable : false,
    client_id: props.clientId,
    user_id: 1 
  }
})

const formErrors = ref({})
const isSubmitting = ref(false)
const editMode = computed(() => props.isEditMode)
const emailInputRef = ref(null)
const formRef = ref(null)

const submitContactForm = async () => {
  formErrors.value = {}
  isSubmitting.value = true
  
  try {
    let valid = true
    if (formRef.value && typeof formRef.value.validate === 'function') {
      const res = await formRef.value.validate()
      valid = (res && typeof res === 'object' && 'valid' in res) ? res.valid : !!res
    }
    if (!valid) {
      isSubmitting.value = false
      return
    }

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

    const backend = error?.response?.data ?? error?.data ?? null

    if (backend?.errors) {
      formErrors.value = { ...backend.errors }
    }
    else if (backend?.message) {
      formErrors.value.general = backend.message
    }
    else if (typeof backend === 'string' && backend.length) {
      formErrors.value.general = backend
    }
    else if (error?.message) {
      formErrors.value.general = error.message
    } else {
      formErrors.value.general = 'An error occurred while saving. Please try again.'
    }

    const gen = String(formErrors.value.general || '').toLowerCase()
    if (gen.includes('duplicate') && gen.includes('email')) {
      formErrors.value.email = formErrors.value.email || ['This email address is already in use by another contact.']
      setTimeout(() => {
        if (emailInputRef.value) emailInputRef.value.focus()
      }, 100)
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
  <VForm ref="formRef" @submit.prevent="submitForm">
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
          :rules="[value => !value || /^\+?[0-9\s\-]{7,20}$/.test(value) || 'Invalid phone number']"
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

      <!-- <VCol cols="12">
        <VSwitch
          v-model="clientForm.contact.is_responsable"
          label="Is Primary Contact"
          color="primary"
          hide-details
        />
      </VCol> -->

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
          :disabled="isSubmitting"
        >
          {{ editMode ? 'Update' : 'Save' }} Contact
        </VBtn>
      </VCol>
    </VRow>
  </VForm>
</template>
