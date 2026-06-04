import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { Plus, Search } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import BotCard from "../components/BotCard";
import CreateBotDialog from "../components/CreateBotDialog";

export default function Bots() {
  const queryClient = useQueryClient();
  const [dialogOpen, setDialogOpen] = useState(false);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");

  const { data: bots = [], isLoading } = useQuery({
    queryKey: ["bots"],
    queryFn: () => base44.entities.Bot.list("-created_date"),
  });

  const createBot = useMutation({
    mutationFn: (data) => base44.entities.Bot.create(data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["bots"] }),
  });

  const filteredBots = bots.filter((bot) => {
    const matchSearch = bot.name?.toLowerCase().includes(search.toLowerCase()) || bot.trading_pair?.toLowerCase().includes(search.toLowerCase());
    const matchStatus = statusFilter === "all" || bot.status === statusFilter;
    return matchSearch && matchStatus;
  });

  const statuses = [
    { value: "all", label: "Все" },
    { value: "active", label: "Активные" },
    { value: "paused", label: "На паузе" },
    { value: "stopped", label: "Остановлены" },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold text-foreground tracking-tight">Боты</h1>
          <p className="text-sm text-muted-foreground mt-1">{bots.length} ботов настроено</p>
        </div>
        <Button onClick={() => setDialogOpen(true)} className="gap-2">
          <Plus className="w-4 h-4" /> Новый бот
        </Button>
      </div>

      <div className="flex flex-col sm:flex-row gap-3">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
          <Input placeholder="Поиск по имени или паре..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9 bg-secondary border-border" />
        </div>
        <div className="flex gap-1.5 overflow-x-auto pb-1">
          {statuses.map((s) => (
            <button key={s.value} onClick={() => setStatusFilter(s.value)}
              className={`px-3 py-1.5 rounded-lg text-xs font-medium whitespace-nowrap transition-colors ${statusFilter === s.value ? "bg-primary/10 text-primary border border-primary/20" : "bg-secondary text-muted-foreground border border-transparent hover:text-foreground"}`}>
              {s.label}
            </button>
          ))}
        </div>
      </div>

      {isLoading ? (
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {Array.from({ length: 6 }).map((_, i) => <div key={i} className="h-48 bg-muted rounded-xl animate-pulse" />)}
        </div>
      ) : filteredBots.length === 0 ? (
        <div className="text-center py-16">
          <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
            <Plus className="w-7 h-7 text-primary" />
          </div>
          <h3 className="text-lg font-semibold text-foreground mb-1">{bots.length === 0 ? "Создайте первого бота" : "Ничего не найдено"}</h3>
          <p className="text-sm text-muted-foreground max-w-sm mx-auto">
            {bots.length === 0 ? "Настройте торговую стратегию и запустите автоматическую торговлю" : "Попробуйте изменить фильтры или поисковый запрос"}
          </p>
          {bots.length === 0 && <Button onClick={() => setDialogOpen(true)} className="mt-4 gap-2"><Plus className="w-4 h-4" /> Создать бота</Button>}
        </div>
      ) : (
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {filteredBots.map((bot) => <BotCard key={bot.id} bot={bot} />)}
        </div>
      )}

      <CreateBotDialog open={dialogOpen} onOpenChange={setDialogOpen} onSubmit={(data) => createBot.mutateAsync(data)} />
    </div>
  );
}
