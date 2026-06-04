import { useState, useEffect, useRef } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { Bell, CheckCheck, ArrowRight } from "lucide-react";
import { Link } from "react-router-dom";
import moment from "moment";

const typeIcon = { trade: "💱", status_change: "⚡", error: "🚨", warning: "⚠️" };

export default function NotificationBell() {
  const [open, setOpen] = useState(false);
  const ref = useRef(null);
  const queryClient = useQueryClient();

  const { data: notifications = [] } = useQuery({
    queryKey: ["notifications"],
    queryFn: () => base44.entities.Notification.list("-created_date", 20),
    refetchInterval: 30000,
  });

  useEffect(() => {
    const unsub = base44.entities.Notification.subscribe(() => {
      queryClient.invalidateQueries({ queryKey: ["notifications"] });
    });
    return unsub;
  }, [queryClient]);

  useEffect(() => {
    const handler = (e) => { if (ref.current && !ref.current.contains(e.target)) setOpen(false); };
    document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, []);

  const markAllRead = useMutation({
    mutationFn: async () => {
      const unread = notifications.filter((n) => !n.is_read);
      await Promise.all(unread.map((n) => base44.entities.Notification.update(n.id, { is_read: true })));
    },
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["notifications"] }),
  });

  const unreadCount = notifications.filter((n) => !n.is_read).length;
  const recent = notifications.slice(0, 6);

  return (
    <div ref__={ref} className="relative">
      <button
        onClick={() => setOpen((o) => !o)}
        className="relative p-2 rounded-lg text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
      >
        <Bell className="w-5 h-5" />
        {unreadCount > 0 && (
          <span className="absolute -top-0.5 -right-0.5 w-4 h-4 bg-primary text-primary-foreground text-[10px] font-bold rounded-full flex items-center justify-center">
            {unreadCount > 9 ? "9+" : unreadCount}
          </span>
        )}
      </button>

      {open && (
        <div className="absolute right-0 top-10 w-80 bg-card border border-border rounded-xl shadow-2xl shadow-black/40 z-50 overflow-hidden">
          <div className="flex items-center justify-between px-4 py-3 border-b border-border">
            <span className="font-semibold text-foreground text-sm">Уведомления</span>
            {unreadCount > 0 && (
              <button onClick={() => markAllRead.mutate()} className="flex items-center gap-1 text-xs text-muted-foreground hover:text-primary transition-colors">
                <CheckCheck className="w-3.5 h-3.5" /> Прочитать все
              </button>
            )}
          </div>
          <div className="max-h-80 overflow-y-auto divide-y divide-border">
            {recent.length === 0 ? (
              <div className="py-8 text-center text-muted-foreground text-sm">
                <Bell className="w-8 h-8 mx-auto mb-2 opacity-30" />
                Нет уведомлений
              </div>
            ) : (
              recent.map((n) => (
                <div key={n.id} className={`px-4 py-3 transition-colors ${!n.is_read ? "bg-primary/5" : "hover:bg-secondary/50"}`}>
                  <div className="flex items-start gap-2.5">
                    <span className="text-base mt-0.5">{typeIcon[n.type] || "🔔"}</span>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center justify-between gap-2">
                        <p className={`text-xs font-semibold truncate ${!n.is_read ? "text-foreground" : "text-muted-foreground"}`}>{n.title}</p>
                        {!n.is_read && <span className="w-1.5 h-1.5 bg-primary rounded-full flex-shrink-0" />}
                      </div>
                      <p className="text-xs text-muted-foreground mt-0.5 line-clamp-2">{n.message}</p>
                      <p className="text-[10px] text-muted-foreground/60 mt-1">{moment(n.created_date).fromNow()}</p>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
          <Link to="/notifications" onClick={() => setOpen(false)} className="flex items-center justify-center gap-1.5 px-4 py-3 text-xs text-primary hover:bg-secondary/50 transition-colors border-t border-border">
            Все уведомления <ArrowRight className="w-3 h-3" />
          </Link>
        </div>
      )}
    </div>
  );
}
