import { $api } from '@/utils/api'

const userService = {
  getUsers(params = {}) {
    return $api('/users', { params })
  },

  getUser(id: number) {
    return $api(`/users/${id}`)
  },

  async createUser(formData: FormData) {
    return await $api('/users', {
      method: 'POST',
      body: formData,
    })
  },

  updateUser(id: number, userData: any) {
    return $api(`/users/${id}`, {
      method: 'PUT',
      body: userData
    })
  },

  deleteUser(id: number) {
    return $api(`/users/${id}`, {
      method: 'DELETE'
    })
  },

  updateUserPassword(userId: number, passwordData: any) {
    return $api(`/users/${userId}/password`, {
      method: 'PUT',
      body: passwordData
    })
  },

  toggleUserStatus(userId: number) {
    return $api(`/users/${userId}/toggle-active`, {
      method: 'POST'
    })
  },

  uploadAvatar(userId: number, formData: FormData) {
    return $api(`/users/${userId}/avatar`, {
      method: 'POST',
      body: formData
    })
  },

  removeAvatar(userId: number) {
    return $api(`/users/${userId}/avatar`, {
      method: 'DELETE'
    })
  },

  getCurrentUser() {
    return $api('/user')
  },
}

export default userService
