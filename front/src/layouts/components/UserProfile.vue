<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue' 
import { useRouter } from 'vue-router' 
import avatar1 from '@images/avatars/avatar-1.png'
import { useAuthStore } from '@/stores/authStore'
import userService from '@/services/userService'

// Add router
const router = useRouter()

// Create loading state
const isLoading = ref(false)
const hasError = ref(false)

// User data with avatar
const userData = reactive({
  id: null, // Add this to store user ID
  first_name: '',
  last_name: '',
  email: '',
  role: '',
  avatar: ''
})

const authStore = useAuthStore()

onMounted(async () => {
  try {
    isLoading.value = true
    const response = await userService.getCurrentUser()
    
    // Update userData with response data
    Object.assign(userData, response)
    
    console.log('User data loaded:', userData)
  } catch (error) {
    console.error('Failed to load user data:', error)
    hasError.value = true
  } finally {
    isLoading.value = false
  }
})

// Handle avatar loading errors
const onAvatarError = () => {
  // Fallback to default avatar if user avatar fails to load
  userData.avatar = ''
}

const handleLogout = () => {
  authStore.logout()
}

// Add navigation to profile page
const navigateToProfile = () => {
  if (userData.id) {
    router.push({ name: 'apps-user-view-id', params: { id: userData.id } })
  }
}

// Computed property to get the correct avatar URL
const avatarSrc = computed(() => {
  if (!userData.avatar) return avatar1
  
  return userData.avatar.startsWith('http') 
    ? userData.avatar 
    : `http://127.0.0.1:8000${userData.avatar.startsWith('/') ? '' : '/'}${userData.avatar}`
})

// Get user's full name
const fullName = computed(() => {
  if (userData.first_name || userData.last_name) {
    return `${userData.first_name || ''} ${userData.last_name || ''}`.trim()
  }
  return 'User'
})
</script>

<template>
  <VBadge
    dot
    location="bottom right"
    offset-x="3"
    offset-y="3"
    bordered
    color="success"
  >
    <VAvatar
      class="cursor-pointer"
      color="primary"
      variant="tonal"
    >
      <!-- Show spinner while loading -->
      <VProgressCircular
        v-if="isLoading"
        indeterminate
        size="small"
        color="white"
      />
      
      <!-- Show avatar when loaded -->
      <VImg 
        v-else
        :src="avatarSrc"
        @error="onAvatarError"
      >
        <template #placeholder>
          <VIcon icon="tabler-user" />
        </template>
      </VImg>

      <!-- SECTION Menu -->
      <VMenu
        activator="parent"
        width="230"
        location="bottom end"
        offset="14px"
      >
        <VList>
          <!-- 👉 User Avatar & Name -->

          <VListItem>
            <template #prepend>
              <VListItemAction start>
                <VBadge
                  dot
                  location="bottom right"
                  offset-x="3"
                  offset-y="3"
                  color="success"
                >
                  <VAvatar
                    color="primary"
                    variant="tonal"
                  >
                    <VImg :src="avatarSrc" @error="onAvatarError" />
                  </VAvatar>
                </VBadge>
              </VListItemAction>
            </template>

            <VListItemTitle class="font-weight-semibold">
              {{ fullName }}
            </VListItemTitle>
            <VListItemSubtitle>{{ userData.role || 'User' }}</VListItemSubtitle>
          </VListItem>

          <VDivider class="my-2" />

          <!-- 👉 Profile -->
          <VListItem link @click="navigateToProfile">
            <template #prepend>
              <VIcon
                class="me-2"
                icon="tabler-user"
                size="22"
              />
            </template>

            <VListItemTitle>Profile</VListItemTitle>
          </VListItem>

          <!-- 👉 Logout -->
          <VListItem to="/login" @click="handleLogout">
            <template #prepend>
              <VIcon
                class="me-2"
                icon="tabler-logout"
                size="22"
              />
            </template>

            <VListItemTitle>Logout</VListItemTitle>
          </VListItem>
        </VList>
      </VMenu>
      <!-- !SECTION -->
    </VAvatar>
  </VBadge>
</template>
