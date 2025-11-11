<script setup lang="ts">
import AuthProvider from '@/views/pages/authentication/AuthProvider.vue'
import { useGenerateImageVariant } from '@core/composable/useGenerateImageVariant'
import blinkLoginImg from '@images/blink_login.png'
import { VNodeRenderer } from '@layouts/components/VNodeRenderer'
import { themeConfig } from '@themeConfig'
import { useAuthStore } from '@/stores/authStore'  
import { useRoute, useRouter } from 'vue-router'  

definePage({
  meta: {
    layout: 'blank',
    public: true,
  },
})

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()
const isLoading = ref(false)
const error = ref('')

const form = ref({
  email: '',
  password: '',
  is_active: true,
  remember: false,
})

const isPasswordVisible = ref(false)

const authThemeImg = blinkLoginImg



const handleLogin = async () => {
  try {
    isLoading.value = true
    error.value = ''

    const loginResult = await authStore.login(form.value.email, form.value.password)

    const user = loginResult?.user ?? (authStore.user ?? null)
    if (user && (user.is_active === 0 || user.is_active === '0' || user.is_active === false)) {
      error.value = 'Compte non actif.'
      return
    }

    if (form.value.remember) {
      localStorage.setItem('remember_email', form.value.email)
    } else {
      localStorage.removeItem('remember_email')
    }

    const redirectPath = route.query.redirect?.toString() || '/'
    router.push(redirectPath)
  } catch (err) {
    console.error('Login error:', err)

    const backendMessage = err?.response?.data?.message ?? err?.data?.message ?? ''
    const backendMsgLower = String(backendMessage).toLowerCase()

    if (backendMsgLower.includes('inactive') || backendMsgLower.includes('not active') || backendMsgLower.includes('non actif') || backendMsgLower.includes('is_active')) {
      error.value = 'Compte non actif.'
    } else if (err.response?.data?.message) {
      error.value = err.response.data.message
    } else {
      error.value = 'Invalid login credentials. Please try again.'
    }
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  const rememberedEmail = localStorage.getItem('remember_email')
  if (rememberedEmail) {
    form.value.email = rememberedEmail
    form.value.remember = true
  }
})
</script>

<template>

  <VRow
    no-gutters
    class="auth-wrapper bg-surface"
  >
    <VCol
      md="8"
      class="d-none d-md-flex"
    >
      <div class="position-relative bg-background w-100 me-0 ">
        <div
          class="d-flex align-center justify-center w-100 h-100 backgorund_blink"
          style="padding-inline: 6.25rem;"
        >
          <VImg
            max-width="613"
            :src="authThemeImg"
            class="auth-illustration mt-16 mb-2"
          />
        </div>

       
      </div>
    </VCol>

    <VCol
      cols="12"
      md="4"
      class="auth-card-v2 d-flex align-center justify-center"
    >
      <VCard
        flat
        :max-width="500"
        class="mt-12 mt-sm-0 pa-6"
      >
        <VCardText>
          <h4 class="text-h4 mb-1">
            Welcome to <span class="text-capitalize">{{ themeConfig.app.title }}</span>! 👋
          </h4>
          <p class="mb-0">
            Sign in to manage your domains and web services
          </p>
        </VCardText>

        <!-- Add error alert -->
        <VCardText v-if="error">
          <VAlert
            color="error"
            variant="tonal"
            closable
            @click:close="error = ''"
          >
            {{ error }}
          </VAlert>
        </VCardText>
        <VCardText>
          <!-- Updated form submission -->
          <VForm @submit.prevent="handleLogin">
            <VRow>
              <!-- email -->
              <VCol cols="12">
                <AppTextField
                  v-model="form.email"
                  autofocus
                  label="Email or Username"
                  type="email"
                  placeholder="johndoe@email.com"
                  :rules="[v => !!v || 'Email is required']"
                />
              </VCol>

              <!-- password -->
              <VCol cols="12">
                <AppTextField
                  v-model="form.password"
                  label="Password"
                  placeholder="············"
                  :type="isPasswordVisible ? 'text' : 'password'"
                  autocomplete="password"
                  :append-inner-icon="isPasswordVisible ? 'tabler-eye-off' : 'tabler-eye'"
                  @click:append-inner="isPasswordVisible = !isPasswordVisible"
                  :rules="[v => !!v || 'Password is required']"
                />

                <div class="d-flex align-center flex-wrap justify-space-between my-6">
                
                </div>

                <VBtn
                  color ="#18134c"
                  block
                  type="submit"
                  :loading="isLoading"
                >
                  Login
                </VBtn>
              </VCol>

            </VRow>
          </VForm>
        </VCardText>

      </VCard>
    </VCol>
  </VRow>
</template>

<style lang="scss">
@use "@core/scss/template/pages/page-auth";
</style>
