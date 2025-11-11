import { $api } from '@/utils/api'

export default {
  async getNotifications() {
    return await $api('/notifications', {
      method: 'GET',
    })
  },

  async markAsRead(ids: number[]) {
    return await $api('/notifications/mark-read', {
      method: 'POST',
      body: { ids },
    })
  },

  async markAsUnread(ids: number[]) {
    return await $api('/notifications/mark-unread', {
      method: 'POST',
      body: { ids },
    })
  },

  async deleteNotification(id: number) {
    return await $api(`/notifications/${id}`, {
      method: 'DELETE',
    })
  },
}