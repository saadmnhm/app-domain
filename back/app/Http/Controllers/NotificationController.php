<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Notification;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $notifications = Notification::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->limit(50)
            ->get()
            ->map(function ($notification) {
                return [
                    'id' => $notification->id,
                    'title' => $notification->title,
                    'subtitle' => $notification->subtitle,
                    'icon' => $notification->icon ?? 'tabler-bell',
                    'color' => $notification->color ?? 'primary',
                    'isSeen' => (bool) $notification->is_seen,
                    'time' => $notification->created_at->diffForHumans(),
                    'data' => $notification->data,
                ];
            });

        return response()->json($notifications);
    }

    public function markAsRead(Request $request)
    {
        $ids = $request->input('ids', []);
        
        Notification::where('user_id', $request->user()->id)
            ->whereIn('id', $ids)
            ->update(['is_seen' => true]);

        return response()->json(['message' => 'Notifications marked as read']);
    }

    public function markAsUnread(Request $request)
    {
        $ids = $request->input('ids', []);
        
        Notification::where('user_id', $request->user()->id)
            ->whereIn('id', $ids)
            ->update(['is_seen' => false]);

        return response()->json(['message' => 'Notifications marked as unread']);
    }

    public function delete($id)
    {
        Notification::where('user_id', auth()->id())
            ->where('id', $id)
            ->delete();

        return response()->json(null, 204);
    }
}