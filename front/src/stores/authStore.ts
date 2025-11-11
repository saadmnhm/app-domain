import { defineStore } from 'pinia'
import { $api } from '@/utils/api'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    token: localStorage.getItem('auth_token'), 
  }),
  
  getters: {
    isAuthenticated: (state) => !!state.token,
  },
  
  actions: {
    async login(email, password) {
      try {
        const response = await $api('/login', {
          method: 'POST',
          body: { email, password }
        })
        
        if (response.access_token) {
          this.token = response.access_token
          localStorage.setItem('auth_token', response.access_token)
          
          // Set cookie using document.cookie API
          const maxAge = 60 * 60 * 24 * 7 // 7 days
          document.cookie = `accessToken=${response.access_token}; path=/; max-age=${maxAge}; SameSite=Lax`
          
          await this.fetchUser()
          return response
        }
      } catch (error) {
        console.error('Login failed:', error)
        throw error
      }
    },
    
    async fetchUser() {
      try {
        const response = await $api('/user')
        this.user = response
        return this.user
      } catch (error) {
        console.error('Failed to fetch user:', error)
        this.logout()
        throw error
      }
    },
    
    async logout() {
      try {
        if (this.token) {
          await $api('/logout', { 
            method: 'POST'
          })
        }
      } catch (error) {
        console.error('Error during logout:', error)
      } finally {
        this.user = null
        this.token = null
        
        localStorage.removeItem('auth_token')
        
        document.cookie = 'accessToken=; path=/; max-age=0'
        
        window.location.href = '/login'
        
        setTimeout(() => {
          window.location.reload()
        }, 1000) 
      }
    }
  }
})
