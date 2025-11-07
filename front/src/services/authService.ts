import { $api } from '@/utils/api'

export default {
  async login(email: string, password: string) {
    const response = await $api('/login', {
      method: 'POST',
      body: { email, password }
    })
    
    if (response.access_token) {
      const accessToken = useCookie('accessToken')
      accessToken.value = response.access_token
    }
    
    return response
  },

  async getCurrentUser() {
    return $api('/user')
  },

  async logout() {
    const response = await $api('/logout', { method: 'POST' })
    const accessToken = useCookie('accessToken')
    accessToken.value = null
    return response
  },

  isAuthenticated() {
    const accessToken = useCookie('accessToken')
    return !!accessToken.value
  }
}
