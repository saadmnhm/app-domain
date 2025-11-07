import { createApp } from 'vue'
import axios from 'axios'
import App from '@/App.vue'
import { registerPlugins } from '@core/utils/plugins'

// Styles
import '@core/scss/template/index.scss'
import '@styles/styles.scss'

// Initialize axios with token if available
const token = localStorage.getItem('auth_token')
if (token) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
}

// Set axios defaults
axios.defaults.withCredentials = true // Important for cookies/CSRF
axios.defaults.baseURL = 'http://localhost:8000'

// Get CSRF token if Laravel requires it
const getCsrfToken = async () => {
  await axios.get('/sanctum/csrf-cookie')
}

// Create vue app
const app = createApp(App)

// Register plugins
registerPlugins(app)

// Mount vue app
app.mount('#app')
