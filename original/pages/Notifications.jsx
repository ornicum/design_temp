import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { Bell, CheckCheck, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import moment from "moment";

const typeIcon = { trade: "💱", status_change: "⚡", error: "🚨", warning: "⚠️" };
const severityBorder = { info: "border-primary/20", success: "border-success/20", warning: "border-warning/20", error: "border-destructive/20" };
const typeLabel = { trade: "Сделка", status_change: "Статус", error: "Ошибка", warning: "Предупреждение" };

export default function Notifications() {
  const queryClient = useQueryClient();

  const { data: notifications = [], isLoading } = useQuery({
    queryKey: ["notifications", "all"],
    queryFn: () => base44.entities.Notification.list("-created_date", 100),
  });

  const markAllRead = useMutation({
    mutationFn: async () => {
      const unread = notifications.filter((n) => !n.is_read);
      await Promise.all(unread.map((n) => base44.entities.Notification.update(n.id, { is_read: true })));
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["notifications"] });
      queryClient.invalidateQueries({ queryKey: ["notifications", "all"] });
    },
  });

  const deleteNotif = useMutation({
    mutationFn: (id) => base44.entities.Notification.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["notifications"] });
      queryClient.invalidateQueries({ queryKey: ["notifications", "all"] });
    },
  });

  const unreadCount = notifications.filter((n) => !n.is_read).length;

  return (
    <div className="max-w-2xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Bell className="w-5 h-5 text-primary" />
          <h1 className="text-xl font-semibold text-foreground">Уведомления</h1>
          {unreadCount > 0 && <span className="px-2 py-0.5 text-xs font-semibold bg-primary/20 text-primary rounded-full">{unreadCount} новых</span>}
        </div>
        {unreadCount > 0 && (
          <Button variant="outline" size="sm" className="border-border gap-1.5 text-muted-foreground" onClick={() => markAllRead.mutate()} disabled={markAllRead.isPending}>
            <CheckCheck className="w-3.5 h-3.5" /> Прочитать все
          </Button>
        )}
      </div>

      {isLoading ? (
        <div className="space-y-3">{Array.from({ length: 5 }).map((_, i) => <div key={i} className="h-16 bg-card border border-border rounded-xl animate-pulse" />)}</div>
      ) : notifications.length === 0 ? (
        <div className="bg-card border border-border rounded-xl py-16 text-center">
          <Bell className="w-12 h-12 mx-auto mb-3 text-muted-foreground opacity-30" />
          <p className="text-muted-foreground">Уведомлений пока нет</p>
          <p className="text-xs text-muted-foreground/60 mt-1">Они появятся когда бот совершит сделку или изменит статус</p>
        </div>
      ) : (
        <div className="space-y-2">
          {notifications.map((n) => (
            <div key={n.id} className={`bg-card border rounded-xl px-4 py-3.5 flex items-start gap-3 transition-colors group ${severityBorder[n.severity] || "border-border"} ${!n.is_read ? "bg-primary/5" : ""}`}>
              <span className="text-xl mt-0.5 flex-shrink-0">{typeIcon[n.type] || "🔔"}</span>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap">
                  <span className="text-xs font-semibold text-muted-foreground uppercase tracking-wide">{typeLabel[n.type]}</span>
                  {n.bot_name && <span className="text-xs text-muted-foreground/60">· {n.bot_name}</span>}
                  {!n.is_read && <span className="w-1.5 h-1.5 bg-primary rounded-full" />}
                </div>
                <p className={`text-sm font-medium mt-0.5 ${!n.is_read ? "text-foreground" : "text-muted-foreground"}`}>{n.title}</p>
                <p className="text-xs text-muted-foreground mt-0.5">{n.message}</p>
                <p className="text-[10px] text-muted-foreground/50 mt-1">{moment(n.created_date).format("DD.MM.YYYY HH:mm")} · {moment(n.created_date).fromNow()}</p>
              </div>
              <button onClick={() => deleteNotif.mutate(n.id)} className="opacity-0 group-hover:opacity-100 text-muted-foreground hover:text-destructive transition-all p-1 flex-shrink-0">
                <Trash2 className="w-3.5 h-3.5" />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
