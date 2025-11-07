import axios from 'axios';

// Configure base URL - adjust this to match your Laravel API
const API_URL = 'http://localhost:8000/api';

const userService = {
  /**
   * Get users with optional filters and pagination
   */
  getUsers(params = {}) {
    return axios.get(`${API_URL}/users`, { params });
  },

  /**
   * Get single user by ID
   */
  getUser(id: number) {
    return axios.get(`${API_URL}/users/${id}`);
  },

  /**
   * Create a new user
   */
  createUser(userData: any) {
    if (userData instanceof FormData) {
      return axios.post(`${API_URL}/users`, userData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
    } else {
      return axios.post(`${API_URL}/users`, userData);
    }
  },

  /**
   * Update existing user
   */
  updateUser(id: number, userData: any) {
    return axios.put(`${API_URL}/users/${id}`, userData);
  },

  /**
   * Delete a user
   */
  deleteUser(id: number) {
    return axios.delete(`${API_URL}/users/${id}`);
  },

  /**
   * Update user password
   */
  updateUserPassword(userId: number, passwordData: any) {
    return axios.put(`${API_URL}/users/${userId}/password`, passwordData);
  },
  /**
   * user status
   */
  toggleUserStatus(userId: number, statusData: any) {
    return axios.post(`${API_URL}/users/${userId}/toggle-active`, statusData);
  },
  /**
   * Upload user avatar
   */
  uploadAvatar(userId: number, formData: any) {
    return axios.post(`${API_URL}/users/${userId}/avatar`, formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    });
  },

  /**
   * Remove user avatar
   */
  removeAvatar(userId: number) {
    return axios.delete(`${API_URL}/users/${userId}/avatar`);
  },
  /**
   * Get the currently authenticated user's information
   */
  getCurrentUser() {
    return axios.get(`${API_URL}/user`);
  },

  /**
   *  CSRF cookie 
   */
  async getCsrfCookie() {
    await axios.get('/sanctum/csrf-cookie');
  },
};

export default userService;
