<script setup lang="ts">
const emit = defineEmits(['provider-login'])

const handleProviderLogin = (provider: string) => {
  emit('provider-login', provider)
}
</script>

<template>
  <div class="auth-provider d-flex flex-wrap gap-3 justify-center">
    <VBtn
      variant="outlined"
      size="large"
      @click="handleProviderLogin('google')"
    >
      <VIcon
        class="me-2"
        icon="mdi-google"
        color="error"
      />
      Google
    </VBtn>
    
    <VBtn
      variant="outlined"
      size="large"
      @click="handleProviderLogin('facebook')"
    >
      <VIcon
        class="me-2"
        icon="mdi-facebook"
        color="primary"
      />
      Facebook
    </VBtn>
    
    <VBtn
      variant="outlined"
      size="large"
      @click="handleProviderLogin('github')"
    >
      <VIcon
        class="me-2"
        icon="mdi-github"
      />
      Github
    </VBtn>
  </div>
</template>
