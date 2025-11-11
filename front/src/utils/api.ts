import { ofetch } from 'ofetch'

function getCookie(name: string): string | null {
  if (typeof document === 'undefined') return null
  
  const value = `; ${document.cookie}`
  const parts = value.split(`; ${name}=`)
  
  if (parts.length === 2) {
    return parts.pop()?.split(';').shift() || null
  }
  
  return null
}

export const $api = ofetch.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
  credentials: 'include', 
  onRequest({ options }) {
    let accessToken = getCookie('accessToken')
    
    if (!accessToken) {
      accessToken = localStorage.getItem('auth_token')
    }
    
    if (accessToken) {
      if (!options.headers) {
        options.headers = {}
      }
      
      if (options.headers instanceof Headers) {
        options.headers.set('Authorization', `Bearer ${accessToken}`)
      } else if (typeof options.headers === 'object') {
        (options.headers as Record<string, string>).Authorization = `Bearer ${accessToken}`
      }
    }
  },
})
