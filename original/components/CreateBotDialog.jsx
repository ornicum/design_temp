import { useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";

const strategies = [
  { value: "grid", label: "Grid Trading" },
  { value: "dca", label: "DCA" },
  { value: "scalping", label: "Scalping" },
  { value: "arbitrage", label: "Арбитраж" },
  { value: "momentum", label: "Momentum" },
  { value: "mean_reversion", label: "Mean Reversion" },
];

const exchanges = [
  { value: "binance", label: "Binance" },
  { value: "bybit", label: "Bybit" },
  { value: "okx", label: "OKX" },
  { value: "kucoin", label: "KuCoin" },
  { value: "kraken", label: "Kraken" },
];

const riskLevels = [
  { value: "low", label: "Низкий" },
  { value: "medium", label: "Средний" },
  { value: "high", label: "Высокий" },
];

export default function CreateBotDialog({ open, onOpenChange, onSubmit, initialData = null }) {
  const isEdit = !!initialData;
  const [form, setForm] = useState(initialData || {
    name: "", description: "", strategy: "", exchange: "", trading_pair: "", initial_capital: "", risk_level: "medium",
  });
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    await onSubmit({
      ...form,
      initial_capital: Number(form.initial_capital),
      current_balance: isEdit ? undefined : Number(form.initial_capital),
    });
    setLoading(false);
    onOpenChange(false);
    if (!isEdit) setForm({ name: "", description: "", strategy: "", exchange: "", trading_pair: "", initial_capital: "", risk_level: "medium" });
  };

  const update = (key, value) => setForm((f) => ({ ...f, [key]: value }));

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-card border-border max-w-md">
        <DialogHeader>
          <DialogTitle className="text-foreground">{isEdit ? "Редактировать бота" : "Создать бота"}</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <Label className="text-sm text-muted-foreground">Название</Label>
            <Input value={form.name} onChange={(e) => update("name", e.target.value)} required className="bg-secondary border-border mt-1" placeholder="Мой бот" />
          </div>
          <div>
            <Label className="text-sm text-muted-foreground">Описание</Label>
            <Textarea value={form.description} onChange={(e) => update("description", e.target.value)} className="bg-secondary border-border mt-1 resize-none" rows={2} placeholder="Опционально" />
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label className="text-sm text-muted-foreground">Стратегия</Label>
              <Select value={form.strategy} onValueChange={(v) => update("strategy", v)}>
                <SelectTrigger className="bg-secondary border-border mt-1"><SelectValue placeholder="Выбрать" /></SelectTrigger>
                <SelectContent className="bg-popover border-border">
                  {strategies.map((s) => <SelectItem key={s.value} value={s.value}>{s.label}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-sm text-muted-foreground">Биржа</Label>
              <Select value={form.exchange} onValueChange={(v) => update("exchange", v)}>
                <SelectTrigger className="bg-secondary border-border mt-1"><SelectValue placeholder="Выбрать" /></SelectTrigger>
                <SelectContent className="bg-popover border-border">
                  {exchanges.map((e) => <SelectItem key={e.value} value={e.value}>{e.label}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label className="text-sm text-muted-foreground">Торговая пара</Label>
              <Input value={form.trading_pair} onChange={(e) => update("trading_pair", e.target.value)} required className="bg-secondary border-border mt-1" placeholder="BTC/USDT" />
            </div>
            <div>
              <Label className="text-sm text-muted-foreground">Начальный капитал ($)</Label>
              <Input type="number" value={form.initial_capital} onChange={(e) => update("initial_capital", e.target.value)} required className="bg-secondary border-border mt-1" placeholder="1000" />
            </div>
          </div>
          <div>
            <Label className="text-sm text-muted-foreground">Уровень риска</Label>
            <Select value={form.risk_level} onValueChange={(v) => update("risk_level", v)}>
              <SelectTrigger className="bg-secondary border-border mt-1"><SelectValue /></SelectTrigger>
              <SelectContent className="bg-popover border-border">
                {riskLevels.map((r) => <SelectItem key={r.value} value={r.value}>{r.label}</SelectItem>)}
              </SelectContent>
            </Select>
          </div>
          <Button type="submit" disabled={loading} className="w-full">
            {loading ? "Сохранение..." : isEdit ? "Сохранить" : "Создать бота"}
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  );
}
