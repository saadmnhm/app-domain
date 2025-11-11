<script lang="ts" setup>
import Notifications from '@/@core/components/Notifications.vue'
import avatar3 from '@images/avatars/avatar-3.png'
import avatar4 from '@images/avatars/avatar-4.png'
import avatar5 from '@images/avatars/avatar-5.png'
import paypal from '@images/cards/paypal-rounded.png'
import { ref } from 'vue'

const notifications = ref([
  { id: 1, img: avatar4, title: 'Congratulation Flora! 🎉', subtitle: 'Won the monthly best seller badge', time: 'Today', isSeen: true },
  { id: 2, text: 'Tom Holland', title: 'New user registered.', subtitle: '5 hours ago', time: 'Yesterday', isSeen: false },
  { id: 3, img: avatar5, title: 'New message received 👋🏻', subtitle: 'You have 10 unread messages', time: '11 Aug', isSeen: true },
  { id: 4, img: paypal, title: 'PayPal', subtitle: 'Received Payment', time: '25 May', isSeen: false, color: 'error' },
])

const removeNotification = (notificationId: number) => {
  notifications.value = notifications.value.filter(n => n.id !== notificationId)
}

const markRead = (ids: number[]) => {
  notifications.value = notifications.value.map(n => ids.includes(n.id) ? { ...n, isSeen: true } : n)
}

const markUnRead = (ids: number[]) => {
  notifications.value = notifications.value.map(n => ids.includes(n.id) ? { ...n, isSeen: false } : n)
}

const handleNotificationClick = (notification) => {
  if (!notification.isSeen) markRead([notification.id])
  // Optionally navigate or open detail
}
</script>

<template>
  <Notifications
    :notifications="notifications"
    @remove="removeNotification"
    @read="markRead"
    @unread="markUnRead"
    @click:notification="handleNotificationClick"
  />
</template>
