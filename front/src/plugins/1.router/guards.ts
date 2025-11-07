import { useAuthStore } from '@/stores/authStore'
import axios from 'axios' // Add this import

// Public routes that don't require authentication
const publicRoutes = [
  'login',
  'pages-authentication-login-v1',
  'pages-authentication-login-v2',
  'pages-authentication-register-v1',
  'pages-authentication-register-v2',
  'pages-authentication-forgot-password-v1',
  'pages-authentication-forgot-password-v2',
  'pages-authentication-reset-password-v1',
  'pages-authentication-reset-password-v2',
  'pages-misc-not-authorized',
  'pages-misc-under-maintenance',
  'pages-misc-error',
  '$error',
]

export const setupGuards = (router) => {
  router.beforeEach(async (to, from, next) => {
    // console.log(`Navigating to: ${to.path}, Route name: ${to.name}`)
    
    try {
      // Try to get the auth store
      const authStore = useAuthStore()
      
      // Initialize axios auth header if token exists
      if (authStore.token) {
        axios.defaults.headers.common['Authorization'] = `Bearer ${authStore.token}`
      }
      
      // Check if the route requires authentication
      const requiresAuth = !publicRoutes.includes(to.name?.toString())
      
      // console.log({
      //   path: to.path,
      //   name: to.name,
      //   requiresAuth,
      //   isAuthenticated: authStore.isAuthenticated
      // })
      
      // If route requires auth and user isn't authenticated
      if (requiresAuth && !authStore.isAuthenticated) {
        // console.log('Unauthorized access, redirecting to login')
        
        // Store the return URL to redirect back after login
        authStore.returnUrl = to.fullPath
        
        // Redirect to login page
        return next({ name: 'login', query: { redirect: to.fullPath } })
      }
      
      // If going to login page but already authenticated
      if (to.name === 'login' && authStore.isAuthenticated) {
        // console.log('Already authenticated, redirecting to home')
        
        // Redirect to home
        return next({ name: 'root' })
      }
      
      // If authenticated but no user data, try to fetch it
      if (authStore.isAuthenticated && !authStore.user) {
        try {
          await authStore.fetchUser()
        } catch (error) {
          // If fetching user fails, go to login
          console.error('Failed to fetch user data', error)
          authStore.logout()
          return next({ name: 'login' })
        }
      }
      
      // Allow navigation
      next()
    } catch (error) {
      console.error('Router guard error:', error)
      next({ name: 'login' })
    }
  })
}
