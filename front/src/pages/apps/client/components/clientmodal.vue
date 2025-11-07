<script setup>
import { ref, computed, defineProps, defineEmits, onMounted, defineExpose } from 'vue'
import clientService from '@/services/clientService'
import domainService from '@/services/domainService' 

const props = defineProps({
  modelValue: Boolean,
  clientData: {
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

const emit = defineEmits(['update:modelValue', 'saved', 'canceled'])

const clientForm = ref({
  categories_id: props.clientData?.categories_id || null,
  raison_sociale: props.clientData?.raison_sociale || '',
  email: props.clientData?.email || '',
  phone: props.clientData?.phone || '',
  website: props.clientData?.website || '',
  ice: props.clientData?.ice || '',
  if: props.clientData?.if || '',
  patente: props.clientData?.patente || '',
  cnss: props.clientData?.cnss || '',
  date_integration: props.clientData?.date_integration || null,
  user_id: 1, 
  domain_id: props.clientData?.domain_id || null 
})

const formErrors = ref({})
const isSubmitting = ref(false)
const categories = ref([])
const domains = ref([]) 

const submitClientForm = async () => {
  formErrors.value = {}
  isSubmitting.value = true
  
  try {
    if (clientForm.value.website && !clientForm.value.website.match(/^https?:\/\//)) {
      clientForm.value.website = 'http://' + clientForm.value.website
    }
    
    let response
    
    if (props.isEditMode && props.clientData?.id) {
      response = await clientService.updateClient(props.clientData.id, clientForm.value)
    } else {
      response = await clientService.createClient(clientForm.value)
    }
    
    emit('update:modelValue', false)
    emit('saved', response.data)
    return response
    
  } catch (error) {
    console.error('Error saving client:', error)
    
    if (error.response?.data?.errors) {
      formErrors.value = error.response.data.errors
    } else if (error.response?.data?.message) {
      formErrors.value.general = error.response.data.message
    } else {
      formErrors.value.general = 'An error occurred while saving. Please try again.'
    }
    throw error
  } finally {
    isSubmitting.value = false
  }
}

const submitForm = async () => {
  return await submitClientForm()
}

const fetchCategories = async () => {
  try {
    const response = await clientService.getCategories()
    categories.value = response.data || response
  } catch (error) {
    console.error('Error fetching categories:', error)
  }
}

const fetchDomains = async () => {
  try {
    const response = await domainService.getDomains()
    domains.value = response.data|| response
  } catch (error) {
    console.error('Error fetching domains:', error)
  }
}

onMounted(() => {
  fetchCategories()
  fetchDomains()
})

const cancelForm = () => {
  emit('update:modelValue', false)
  emit('canceled')
}

defineExpose({
  submitForm
})
</script>

<template>
  <VForm @submit.prevent="submitClientForm">
    <VAlert
      v-if="formErrors.general"
      type="error"
      variant="tonal"
      closable
      class="mb-4"
    >
      {{ formErrors.general }}
    </VAlert>
    
    <h6 class="text-h6 mb-3">Client Information</h6>
    
    <VRow>
      <!-- Category Selection -->
      <VCol cols="12">
        <VSelect
          v-model="clientForm.categories_id"
          :items="categories"
          item-title="label"
          item-value="id"
          label="Category"
          :error-messages="formErrors.categories_id"
          required
        />
      </VCol>

      <!-- Domaine d'activité Selection -->
      <VCol cols="12">
        <VSelect
          v-model="clientForm.domain_id"
          :items="domains"
          item-title="label"
          item-value="id"
          label="Domaine d'activité"
          :error-messages="formErrors.domain_id"
          required
        />
      </VCol>
      
      <!-- Raison Sociale (Company Name) -->
      <VCol cols="12">
        <VTextField
          v-model="clientForm.raison_sociale"
          label="Raison Sociale"
          :error-messages="formErrors.raison_sociale"
          required
          autofocus
        />
      </VCol>
      
      <!-- Email -->
      <VCol cols="12" md="6">
        <VTextField
          v-model="clientForm.email"
          label="Email"
          type="email"
          :error-messages="formErrors.email"
          required
        />
      </VCol>
      
      <!-- Phone -->
      <VCol cols="12" md="6">
        <VTextField
          v-model="clientForm.phone"
          label="Phone"
          :error-messages="formErrors.phone"
        />
      </VCol>
      
      <!-- Website -->
      <VCol cols="12" md="8">
        <VTextField
          v-model="clientForm.website"
          label="Website"
          :error-messages="formErrors.website"
          hint="Include http:// or https:// for valid websites"
          persistent-hint
        />
      </VCol>
      
      <!-- ICE (Fiscal Identifier) -->
      <VCol cols="12" md="4">
        <VTextField
          v-model="clientForm.ice"
          label="ICE"
          :error-messages="formErrors.ice"
        />
      </VCol>

      <!-- IF (Fiscal Identifier) -->
      <VCol cols="12" md="4">
        <VTextField
          v-model="clientForm.if"
          label="IF"
          :error-messages="formErrors.if"
        />
      </VCol>
      
      <!-- Patente -->
      <VCol cols="12" md="4">
        <VTextField
          v-model="clientForm.patente"
          label="Patente"
          :error-messages="formErrors.patente"
        />
      </VCol>
      
      <!-- CNSS -->
      <VCol cols="12" md="4">
        <VTextField
          v-model="clientForm.cnss"
          label="CNSS"
          :error-messages="formErrors.cnss"
        />
      </VCol>
      
      <!-- Date Integration -->
      <VCol cols="12">
        <VTextField
          v-model="clientForm.date_integration"
          label="Integration Date"
          type="date"
          :error-messages="formErrors.date_integration"
        />
      </VCol>
    </VRow>

    <VDivider class="my-4" />
    
  </VForm>
</template>
