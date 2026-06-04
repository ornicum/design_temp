import { useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { Slider } from "@/components/ui/slider";
import { ArrowLeft, Bot, Save, AlertTriangle } from "lucide-react";
import { Link } from "react-router-dom";

const strategies = [
  { value: "grid", label: "Grid Trading", desc: "Сетка ордеров в заданном диапазоне цен" },
  { value: "dca", label: "DCA", desc: "Регулярные покупки по расписанию или просадке" },
  { value: "scalping", label: "Scalping", desc: "Высокочастотные сделки с малым таргетом" },
  { value: "arbitrage", label: "Арбитраж", desc: "Использование разницы цен между биржами" },
  { value: "momentum", label: "Momentum", desc: "Следование тренду по техническим индикаторам" },
  { value: "mean_reversion", label: "Mean Reversion", desc: "Торговля на откатах от среднего значения" },
];

const exchanges = [
  { value: "binance", label: "Binance" },
  { value: "bybit", label: "Bybit" },
  { value: "okx", label: "OKX" },
  { value: "kucoin", label: "KuCoin" },
  { value: "kraken", label: "Kraken" },
];

const riskLevels = [
  { value: "low", label: "Низкий", color: "text-success" },
  { value: "medium", label: "Средний", color: "text-warning" },
  { value: "high", label: "Высокий", color: "text-destructive" },
];

const popularPairs = ["BTC/USDT", "ETH/USDT", "SOL/USDT", "BNB/USDT", "XRP/USDT", "ADA/USDT", "AVAX/USDT", "DOT/USDT", "DOGE/USDT", "MATIC/USDT"];

const defaultForm = {
  name: "", description: "", strategy: "", exchange: "", trading_pair: "",
  initial_capital: "", risk_level: "medium", max_trade_size: "", min_trade_size: "",
  max_open_trades: "3", stop_loss_percent: "5", take_profit_percent: "10",
  max_daily_trades: "", max_drawdown_limit: "15",
};

export default function BotSettings() {
  const { botId } = useParams();
  const navigate = useNavigate();
  const queryClient = useQueryClient();
  const isEdit = !!botId;

  const { data: existingBot, isLoading } = useQuery({
    queryKey: ["bot", botId],
    queryFn: () => base44.entities.Bot.get(botId),
    enabled: isEdit,
  });

  const [form, setForm] = useState(() => defaultForm);
  const [initialized, setInitialized] = useState(false);

  if (isEdit && existingBot && !initialized) {
    setForm({
      name: existingBot.name || "",
      description: existingBot.description || "",
      strategy: existingBot.strategy || "",
      exchange: existingBot.exchange || "",
      trading_pair: existingBot.trading_pair || "",
      initial_capital: existingBot.initial_capital?.toString() || "",
      risk_level: existingBot.risk_level || "medium",
      max_trade_size: existingBot.max_trade_size?.toString() || "",
      min_trade_size: existingBot.min_trade_size?.toString() || "",
      max_open_trades: existingBot.max_open_trades?.toString() || "3",
      stop_loss_percent: existingBot.stop_loss_percent?.toString() || "5",
      take_profit_percent: existingBot.take_profit_percent?.toString() || "10",
      max_daily_trades: existingBot.max_daily_trades?.toString() || "",
      max_drawdown_limit: existingBot.max_drawdown_limit?.toString() || "15",
    });
    setInitialized(true);
  }

  const mutation = useMutation({
    mutationFn: (data) => isEdit
      ? base44.entities.Bot.update(botId, data)
      : base44.entities.Bot.create(data),
    onSuccess: (result) => {
      queryClient.invalidateQueries({ queryKey: ["bots"] });
      navigate(isEdit ? `/bots/${botId}` : `/bots/${result.id}`);
    },
  });

  const update = (key, value) => setForm((f) => ({ ...f, [key]: value }));

  const handleSubmit = (e) => {
    e.preventDefault();
    mutation.mutate({
      ...form,
      initial_capital: Number(form.initial_capital),
      current_balance: isEdit ? undefined : Number(form.initial_capital),
      max_trade_size: form.max_trade_size ? Number(form.max_trade_size) : undefined,
      min_trade_size: form.min_trade_size ? Number(form.min_trade_size) : undefined,
      max_open_trades: Number(form.max_open_trades),
      stop_loss_percent: Number(form.stop_loss_percent),
      take_profit_percent: Number(form.take_profit_percent),
      max_daily_trades: form.max_daily_trades ? Number(form.max_daily_trades) : undefined,
      max_drawdown_limit: Number(form.max_drawdown_limit),
    });
  };

  if (isLoading) {
    return (
      <div className="p-6 flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary/30 border-t-primary rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="p-4 md:p-6 max-w-3xl mx-auto">
      <div className="flex items-center gap-3 mb-6">
        <Link to={isEdit ? `/bots/${botId}` : "/bots"} className="text-muted-foreground hover:text-foreground transition-colors">
          <ArrowLeft className="w-5 h-5" />
        </Link>
        <div className="flex items-center gap-2">
          <Bot className="w-5 h-5 text-primary" />
          <h1 className="text-xl font-semibold text-foreground">
            {isEdit ? "Настройки бота" : "Создать нового бота"}
          </h1>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        <section className="bg-card border border-border rounded-xl p-5 space-y-4">
          <h2 className="font-semibold text-foreground text-sm uppercase tracking-wide text-muted-foreground">Основные параметры</h2>
          <div>
            <Label className="text-sm text-muted-foreground mb-1 block">Название бота *</Label>
            <Input value={form.name} onChange={(e) => update("name", e.target.value)} required placeholder="Мой BTC Grid Bot" className="bg-secondary border-border" />
          </div>
          <div>
            <Label className="text-sm text-muted-foreground mb-1 block">Описание</Label>
            <Textarea value={form.description} onChange={(e) => update("description", e.target.value)} placeholder="Опишите стратегию..." className="bg-secondary border-border resize-none" rows={2} />
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-sm text-muted-foreground mb-1 block">Биржа *</Label>
              <Select value={form.exchange} onValueChange={(v) => update("exchange", v)}>
                <SelectTrigger className="bg-secondary border-border"><SelectValue placeholder="Выбрать биржу" /></SelectTrigger>
                <SelectContent className="bg-popover border-border">
                  {exchanges.map((e) => <SelectItem key={e.value} value={e.value}>{e.label}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-sm text-muted-foreground mb-1 block">Уровень риска</Label>
              <Select value={form.risk_level} onValueChange={(v) => update("risk_level", v)}>
                <SelectTrigger className="bg-secondary border-border"><SelectValue /></SelectTrigger>
                <SelectContent className="bg-popover border-border">
                  {riskLevels.map((r) => <SelectItem key={r.value} value={r.value}><span className={r.color}>{r.label}</span></SelectItem>)}
                </SelectContent>
              </Select>
            </div>
          </div>
        </section>

        <section className="bg-card border border-border rounded-xl p-5 space-y-4">
          <h2 className="font-semibold text-sm uppercase tracking-wide text-muted-foreground">Стратегия</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {strategies.map((s) => (
              <button
                key={s.value}
                type="button"
                onClick={() => update("strategy", s.value)}
                className={`text-left p-3 rounded-lg border transition-all ${form.strategy === s.value ? "border-primary bg-primary/10 text-foreground" : "border-border bg-secondary hover:border-primary/30 text-muted-foreground hover:text-foreground"}`}
              >
                <div className="font-medium text-sm">{s.label}</div>
                <div className="text-xs mt-0.5 opacity-70">{s.desc}</div>
              </button>
            ))}
          </div>
        </section>

        <section className="bg-card border border-border rounded-xl p-5 space-y-4">
          <h2 className="font-semibold text-sm uppercase tracking-wide text-muted-foreground">Торговая пара и капитал</h2>
          <div>
            <Label className="text-sm text-muted-foreground mb-2 block">Торговая пара *</Label>
            <div className="flex flex-wrap gap-2 mb-2">
              {popularPairs.map((pair) => (
                <button
                  key={pair}
                  type="button"
                  onClick={() => update("trading_pair", pair)}
                  className={`px-3 py-1 rounded-md text-xs font-mono border transition-all ${form.trading_pair === pair ? "border-primary bg-primary/10 text-primary" : "border-border bg-secondary text-muted-foreground hover:border-primary/40"}`}
                >
                  {pair}
                </button>
              ))}
            </div>
            <Input value={form.trading_pair} onChange={(e) => update("trading_pair", e.target.value.toUpperCase())} required placeholder="Или введите вручную: BTC/USDT" className="bg-secondary border-border font-mono" />
          </div>
          <div>
            <Label className="text-sm text-muted-foreground mb-1 block">Начальный капитал ($) *</Label>
            <Input type="number" value={form.initial_capital} onChange={(e) => update("initial_capital", e.target.value)} required placeholder="1000" min="1" className="bg-secondary border-border font-mono" />
          </div>
        </section>

        <section className="bg-card border border-border rounded-xl p-5 space-y-5">
          <h2 className="font-semibold text-sm uppercase tracking-wide text-muted-foreground">Лимиты на сделки</h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-sm text-muted-foreground mb-1 block">Мин. размер сделки ($)</Label>
              <Input type="number" value={form.min_trade_size} onChange={(e) => update("min_trade_size", e.target.value)} placeholder="10" min="0" className="bg-secondary border-border font-mono" />
            </div>
            <div>
              <Label className="text-sm text-muted-foreground mb-1 block">Макс. размер сделки ($)</Label>
              <Input type="number" value={form.max_trade_size} onChange={(e) => update("max_trade_size", e.target.value)} placeholder="500" min="0" className="bg-secondary border-border font-mono" />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-sm text-muted-foreground mb-1 block">Макс. открытых позиций: <span className="text-foreground font-mono">{form.max_open_trades}</span></Label>
              <Slider value={[Number(form.max_open_trades)]} onValueChange={([v]) => update("max_open_trades", String(v))} min={1} max={20} step={1} className="mt-3" />
            </div>
            <div>
              <Label className="text-sm text-muted-foreground mb-1 block">Макс. сделок в день</Label>
              <Input type="number" value={form.max_daily_trades} onChange={(e) => update("max_daily_trades", e.target.value)} placeholder="Без ограничений" min="1" className="bg-secondary border-border font-mono" />
            </div>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
            <div>
              <div className="flex items-center justify-between mb-2">
                <Label className="text-sm text-muted-foreground">Стоп-лосс (%)</Label>
                <span className="text-destructive font-mono text-sm font-semibold">{form.stop_loss_percent}%</span>
              </div>
              <Slider value={[Number(form.stop_loss_percent)]} onValueChange={([v]) => update("stop_loss_percent", String(v))} min={0.5} max={30} step={0.5} className="mt-2" />
            </div>
            <div>
              <div className="flex items-center justify-between mb-2">
                <Label className="text-sm text-muted-foreground">Тейк-профит (%)</Label>
                <span className="text-success font-mono text-sm font-semibold">{form.take_profit_percent}%</span>
              </div>
              <Slider value={[Number(form.take_profit_percent)]} onValueChange={([v]) => update("take_profit_percent", String(v))} min={0.5} max={50} step={0.5} className="mt-2" />
            </div>
          </div>

          <div>
            <div className="flex items-center justify-between mb-2">
              <Label className="text-sm text-muted-foreground flex items-center gap-1.5">
                <AlertTriangle className="w-3.5 h-3.5 text-warning" />
                Лимит просадки (%)
              </Label>
              <span className="text-warning font-mono text-sm font-semibold">{form.max_drawdown_limit}%</span>
            </div>
            <Slider value={[Number(form.max_drawdown_limit)]} onValueChange={([v]) => update("max_drawdown_limit", String(v))} min={1} max={50} step={1} />
            <p className="text-xs text-muted-foreground mt-1.5">Бот автоматически остановится при достижении этого уровня просадки</p>
          </div>
        </section>

        <div className="flex gap-3 pb-6">
          <Button type="button" variant="outline" className="flex-1 border-border" onClick={() => navigate(isEdit ? `/bots/${botId}` : "/bots")}>
            Отмена
          </Button>
          <Button type="submit" disabled={mutation.isPending} className="flex-1">
            <Save className="w-4 h-4 mr-2" />
            {mutation.isPending ? "Сохранение..." : isEdit ? "Сохранить изменения" : "Создать бота"}
          </Button>
        </div>
      </form>
    </div>
  );
}
