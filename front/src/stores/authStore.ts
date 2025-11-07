import { defineStore } from 'pinia'
import axios from 'axios'

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
        const response = await axios.post('http://localhost:8000/api/login', { email, password })
        
        if (response.data.access_token) {
          this.token = response.data.access_token
          localStorage.setItem('auth_token', response.data.access_token)
          
          // Set axios default auth header
          axios.defaults.headers.common['Authorization'] = `Bearer ${this.token}`
          
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
        const response = await axios.get('http://localhost:8000/api/user')
        this.user = response.data
        return this.user
      } catch (error) {
        console.error('Failed to fetch user:', error)
        this.logout()
        throw error
      }
    },
    
    async logout() {
      try {
        // Call backend to invalidate token if available
        if (this.token) {
          await axios.post('/api/logout')
        }
      } catch (error) {
        console.error('Error during logout:', error)
      } finally {
        // Always clean up local state
        this.user = null
        this.token = null
        
        // Remove from localStorage
        localStorage.removeItem('auth_token')
        
        // Remove auth header
        delete axios.defaults.headers.common['Authorization']
        
        // First redirect to login page
        window.location.href = '/login'
        
        // Then force a complete page reload
        // This ensures all app state is cleared
        setTimeout(() => {
          window.location.reload()
        }, 100) 
      }
    }
  }
})
