import { useState, useEffect } from "react";
import { useAuth } from "@/lib/AuthContext";
import { base44 } from "@/api/base44Client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { toast } from "sonner";
import { User, Bell, Shield } from "lucide-react";

export default function Settings() {
  const { user } = useAuth();
  const [notifications, setNotifications] = useState(true);
  const [darkMode] = useState(true);

  return (
    <div className="space-y-6 max-w-2xl">
      <div>
        <h1 className="text-2xl font-semibold text-foreground tracking-tight">Настройки</h1>
        <p className="text-sm text-muted-foreground mt-1">Управление аккаунтом и предпочтениями</p>
      </div>

      <div className="bg-card border border-border rounded-xl p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-9 h-9 rounded-lg bg-primary/10 flex items-center justify-center">
            <User className="w-4 h-4 text-primary" />
          </div>
          <h2 className="font-semibold text-foreground">Профиль</h2>
        </div>
        <div className="space-y-4">
          <div>
            <Label className="text-sm text-muted-foreground">Имя</Label>
            <Input value={user?.full_name || ""} disabled className="bg-secondary border-border mt-1" />
          </div>
          <div>
            <Label className="text-sm text-muted-foreground">Email</Label>
            <Input value={user?.email || ""} disabled className="bg-secondary border-border mt-1" />
          </div>
        </div>
      </div>

      <div className="bg-card border border-border rounded-xl p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-9 h-9 rounded-lg bg-primary/10 flex items-center justify-center">
            <Bell className="w-4 h-4 text-primary" />
          </div>
          <h2 className="font-semibold text-foreground">Уведомления</h2>
        </div>
        <div className="space-y-4">
          {[
            { label: "Уведомления о сделках", desc: "Получать уведомления при исполнении сделок", key: "trades" },
            { label: "Алерты ботов", desc: "Уведомления об ошибках и изменениях статуса", key: "bots" },
            { label: "Еженедельный отчёт", desc: "Сводка по результатам торговли за неделю", key: "weekly" },
          ].map((item) => (
            <div key={item.key} className="flex items-center justify-between py-2">
              <div>
                <p className="text-sm font-medium text-foreground">{item.label}</p>
                <p className="text-xs text-muted-foreground mt-0.5">{item.desc}</p>
              </div>
              <Switch checked={notifications} onCheckedChange={setNotifications} />
            </div>
          ))}
        </div>
      </div>

      <div className="bg-card border border-border rounded-xl p-5">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-9 h-9 rounded-lg bg-primary/10 flex items-center justify-center">
            <Shield className="w-4 h-4 text-primary" />
          </div>
          <h2 className="font-semibold text-foreground">Безопасность</h2>
        </div>
        <div className="space-y-3">
          <div className="flex items-center justify-between py-2">
            <div>
              <p className="text-sm font-medium text-foreground">Двухфакторная аутентификация</p>
              <p className="text-xs text-muted-foreground mt-0.5">Дополнительный уровень защиты аккаунта</p>
            </div>
            <Button variant="outline" size="sm" className="border-border text-muted-foreground" onClick={() => toast.info("Функция скоро будет доступна")}>
              Настроить
            </Button>
          </div>
        </div>
      </div>

      <Button variant="destructive" className="w-full sm:w-auto" onClick={() => base44.auth.logout()}>
        Выйти из аккаунта
      </Button>
    </div>
  );
}
