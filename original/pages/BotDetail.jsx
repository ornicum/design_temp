import { useParams, useNavigate } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { useState } from "react";
import { ArrowLeft, Play, Pause, Square, Pencil, Trash2, AlertTriangle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle } from "@/components/ui/alert-dialog";
import BotStatusBadge from "../components/BotStatusBadge";
import RecentTradesTable from "../components/RecentTradesTable";
import CreateBotDialog from "../components/CreateBotDialog";
import BotPerformanceChart from "../components/BotPerformanceChart";

const strategyLabels = {
  grid: "Grid Trading", dca: "DCA", scalping: "Scalping",
  arbitrage: "Арбитраж", momentum: "Momentum", mean_reversion: "Mean Reversion",
};
const riskLabels = { low: "Низкий", medium: "Средний", high: "Высокий" };
const riskColors = { low: "text-success", medium: "text-warning", high: "text-destructive" };

export default function BotDetail() {
  const { botId } = useParams();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const [editOpen, setEditOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const { data: bot, isLoading } = useQuery({
    queryKey: ["bot", botId],
    queryFn: () => base44.entities.Bot.get(botId),
  });

  const updateBot = useMutation({
    mutationFn: (data) => base44.entities.Bot.update(botId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bot", botId] });
      queryClient.invalidateQueries({ queryKey: ["bots"] });
    },
  });

  const deleteBot = useMutation({
    mutationFn: () => base44.entities.Bot.delete(botId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bots"] });
      navigate("/bots");
    },
  });

  const toggleStatus = (newStatus) => {
    const prevStatus = bot.status;
    updateBot.mutate({ status: newStatus }, {
      onSuccess: () => {
        const statusLabels = { active: "Активен", paused: "На паузе", stopped: "Остановлен", error: "Ошибка" };
        base44.entities.Notification.create({
          bot_id: botId, bot_name: bot.name, type: "status_change",
          title: `${bot.name}: статус изменён`,
          message: `Статус бота изменён с «${statusLabels[prevStatus] || prevStatus}» на «${statusLabels[newStatus] || newStatus}»`,
          severity: newStatus === "error" ? "error" : newStatus === "stopped" ? "warning" : "info",
          is_read: false,
        });
      }
    });
  };

  if (isLoading) {
    return (
      <div className="space-y-6 animate-pulse">
        <div className="h-8 bg-muted rounded w-48" />
        <div className="h-40 bg-muted rounded-xl" />
        <div className="h-64 bg-muted rounded-xl" />
      </div>
    );
  }

  if (!bot) {
    return (
      <div className="text-center py-16">
        <p className="text-muted-foreground">Бот не найден</p>
        <Button variant="ghost" onClick={() => navigate("/bots")} className="mt-2">← Вернуться</Button>
      </div>
    );
  }

  const isPositive = (bot.profit_loss || 0) >= 0;

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={() => navigate("/bots")} className="text-muted-foreground hover:text-foreground">
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div className="flex-1">
          <div className="flex items-center gap-3 flex-wrap">
            <h1 className="text-2xl font-semibold text-foreground tracking-tight">{bot.name}</h1>
            <BotStatusBadge status={bot.status} />
          </div>
          <p className="text-sm text-muted-foreground mt-0.5">
            {bot.exchange?.toUpperCase()} · {bot.trading_pair} · {strategyLabels[bot.strategy]}
          </p>
        </div>
        <div className="flex items-center gap-2">
          {bot.status === "active" ? (
            <Button variant="outline" size="sm" onClick={() => toggleStatus("paused")} className="gap-1.5 border-border text-muted-foreground">
              <Pause className="w-3.5 h-3.5" /> Пауза
            </Button>
          ) : (
            <Button size="sm" onClick={() => toggleStatus("active")} className="gap-1.5">
              <Play className="w-3.5 h-3.5" /> Запустить
            </Button>
          )}
          {bot.status !== "stopped" && (
            <Button variant="outline" size="sm" onClick={() => toggleStatus("stopped")} className="gap-1.5 border-border text-muted-foreground">
              <Square className="w-3.5 h-3.5" /> Стоп
            </Button>
          )}
          <Button variant="ghost" size="icon" onClick={() => setEditOpen(true)} className="text-muted-foreground">
            <Pencil className="w-4 h-4" />
          </Button>
          <Button variant="ghost" size="icon" onClick={() => setDeleteOpen(true)} className="text-destructive/70 hover:text-destructive">
            <Trash2 className="w-4 h-4" />
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {[
          { label: "Баланс", value: `$${(bot.current_balance || bot.initial_capital || 0).toLocaleString()}` },
          { label: "PnL", value: `${isPositive ? "+" : ""}$${(bot.profit_loss || 0).toFixed(2)}`, color: isPositive ? "text-success" : "text-destructive" },
          { label: "Win Rate", value: `${(bot.win_rate || 0).toFixed(1)}%` },
          { label: "Макс. просадка", value: `${(bot.max_drawdown || 0).toFixed(1)}%`, color: "text-destructive" },
        ].map((stat) => (
          <div key={stat.label} className="bg-card border border-border rounded-xl p-4">
            <span className="text-xs text-muted-foreground">{stat.label}</span>
            <p className={`text-lg font-mono font-semibold mt-1 ${stat.color || "text-foreground"}`}>{stat.value}</p>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
        {[
          { label: "Начальный капитал", value: `$${(bot.initial_capital || 0).toLocaleString()}` },
          { label: "Всего сделок", value: bot.total_trades || 0 },
          { label: "Уровень риска", value: riskLabels[bot.risk_level] || bot.risk_level, color: riskColors[bot.risk_level] },
          { label: "Доходность (%)", value: `${isPositive ? "+" : ""}${(bot.profit_loss_percent || 0).toFixed(2)}%`, color: isPositive ? "text-success" : "text-destructive" },
        ].map((stat) => (
          <div key={stat.label} className="bg-card border border-border rounded-xl p-4">
            <span className="text-xs text-muted-foreground">{stat.label}</span>
            <p className={`text-lg font-mono font-semibold mt-1 ${stat.color || "text-foreground"}`}>{stat.value}</p>
          </div>
        ))}
      </div>

      <BotPerformanceChart />
      <RecentTradesTable botId={botId} limit={15} />

      {bot.description && (
        <div className="bg-card border border-border rounded-xl p-5">
          <h3 className="font-semibold text-foreground mb-2">Описание</h3>
          <p className="text-sm text-muted-foreground">{bot.description}</p>
        </div>
      )}

      <CreateBotDialog
        open={editOpen}
        onOpenChange={setEditOpen}
        initialData={bot}
        onSubmit={(data) => updateBot.mutateAsync(data)}
      />

      <AlertDialog open={deleteOpen} onOpenChange={setDeleteOpen}>
        <AlertDialogContent className="bg-card border-border">
          <AlertDialogHeader>
            <AlertDialogTitle className="flex items-center gap-2 text-foreground">
              <AlertTriangle className="w-5 h-5 text-destructive" /> Удалить бота?
            </AlertDialogTitle>
            <AlertDialogDescription>
              Бот «{bot.name}» будет удалён навсегда. Это действие нельзя отменить.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel className="border-border text-muted-foreground">Отмена</AlertDialogCancel>
            <AlertDialogAction onClick={() => deleteBot.mutate()} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
              Удалить
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
