import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { base44 } from "@/api/base44Client";
import { Plus, Key, Trash2, AlertTriangle, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle } from "@/components/ui/alert-dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

const exchanges = [
  { value: "binance", label: "Binance" },
  { value: "bybit", label: "Bybit" },
  { value: "okx", label: "OKX" },
  { value: "kucoin", label: "KuCoin" },
  { value: "kraken", label: "Kraken" },
];

export default function ApiKeys() {
  const queryClient = useQueryClient();
  const [createOpen, setCreateOpen] = useState(false);
  const [deleteId, setDeleteId] = useState(null);
  const [editKey, setEditKey] = useState(null);
  const [form, setForm] = useState({ label: "", exchange: "", api_key_masked: "", permissions: "read_only" });

  const { data: keys = [], isLoading } = useQuery({
    queryKey: ["api-keys"],
    queryFn: () => base44.entities.ApiKey.list("-created_date"),
  });

  const createKey = useMutation({
    mutationFn: (data) => base44.entities.ApiKey.create(data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["api-keys"] }); setCreateOpen(false); resetForm(); },
  });

  const updateKey = useMutation({
    mutationFn: ({ id, data }) => base44.entities.ApiKey.update(id, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["api-keys"] }); setEditKey(null); resetForm(); },
  });

  const deleteKey = useMutation({
    mutationFn: (id) => base44.entities.ApiKey.delete(id),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ["api-keys"] }); setDeleteId(null); },
  });

  const resetForm = () => setForm({ label: "", exchange: "", api_key_masked: "", permissions: "read_only" });

  const openEdit = (key) => {
    setEditKey(key);
    setForm({ label: key.label, exchange: key.exchange, api_key_masked: key.api_key_masked, permissions: key.permissions || "read_only" });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editKey) {
      updateKey.mutate({ id: editKey.id, data: form });
    } else {
      createKey.mutate(form);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold text-foreground tracking-tight">API Ключи</h1>
          <p className="text-sm text-muted-foreground mt-1">Управляйте подключениями к биржам</p>
        </div>
        <Button onClick={() => { resetForm(); setCreateOpen(true); }} className="gap-2">
          <Plus className="w-4 h-4" /> Добавить ключ
        </Button>
      </div>

      <div className="bg-card border border-primary/20 rounded-xl p-4 flex items-start gap-3">
        <Shield className="w-5 h-5 text-primary mt-0.5 flex-shrink-0" />
        <div>
          <p className="text-sm font-medium text-foreground">Безопасность</p>
          <p className="text-xs text-muted-foreground mt-0.5">API ключи хранятся в зашифрованном виде. Рекомендуем использовать ключи только с правами на чтение и торговлю, без вывода средств.</p>
        </div>
      </div>

      {isLoading ? (
        <div className="space-y-3">{Array.from({ length: 3 }).map((_, i) => <div key={i} className="h-20 bg-muted rounded-xl animate-pulse" />)}</div>
      ) : keys.length === 0 ? (
        <div className="text-center py-16">
          <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
            <Key className="w-7 h-7 text-primary" />
          </div>
          <h3 className="text-lg font-semibold text-foreground mb-1">Нет API ключей</h3>
          <p className="text-sm text-muted-foreground max-w-sm mx-auto">Подключите биржевой аккаунт для начала торговли</p>
          <Button onClick={() => setCreateOpen(true)} className="mt-4 gap-2"><Plus className="w-4 h-4" /> Добавить ключ</Button>
        </div>
      ) : (
        <div className="space-y-3">
          {keys.map((key) => (
            <div key={key.id} className="bg-card border border-border rounded-xl p-4 flex items-center justify-between hover:border-primary/20 transition-colors group">
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
                  <Key className="w-4 h-4 text-primary" />
                </div>
                <div>
                  <p className="font-medium text-foreground text-sm">{key.label}</p>
                  <div className="flex items-center gap-2 mt-0.5">
                    <span className="text-xs text-muted-foreground font-mono">{key.exchange?.toUpperCase()}</span>
                    <span className="text-muted-foreground text-xs">·</span>
                    <span className="text-xs font-mono text-muted-foreground">{key.api_key_masked}</span>
                  </div>
                </div>
              </div>
              <div className="flex items-center gap-1">
                <Button variant="ghost" size="sm" onClick={() => openEdit(key)} className="text-muted-foreground text-xs">Изменить</Button>
                <Button variant="ghost" size="icon" onClick={() => setDeleteId(key.id)} className="text-destructive/50 hover:text-destructive">
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>
            </div>
          ))}
        </div>
      )}

      <Dialog open={createOpen || !!editKey} onOpenChange={(v) => { if (!v) { setCreateOpen(false); setEditKey(null); resetForm(); } }}>
        <DialogContent className="bg-card border-border max-w-md">
          <DialogHeader><DialogTitle className="text-foreground">{editKey ? "Изменить ключ" : "Добавить API ключ"}</DialogTitle></DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label className="text-sm text-muted-foreground">Название</Label>
              <Input value={form.label} onChange={(e) => setForm({ ...form, label: e.target.value })} required className="bg-secondary border-border mt-1" placeholder="Мой Binance" />
            </div>
            <div>
              <Label className="text-sm text-muted-foreground">Биржа</Label>
              <Select value={form.exchange} onValueChange={(v) => setForm({ ...form, exchange: v })}>
                <SelectTrigger className="bg-secondary border-border mt-1"><SelectValue placeholder="Выбрать" /></SelectTrigger>
                <SelectContent className="bg-popover border-border">
                  {exchanges.map((e) => <SelectItem key={e.value} value={e.value}>{e.label}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-sm text-muted-foreground">API Key</Label>
              <Input value={form.api_key_masked} onChange={(e) => setForm({ ...form, api_key_masked: e.target.value })} required className="bg-secondary border-border mt-1 font-mono" placeholder="xxxx-xxxx-xxxx" />
            </div>
            <Button type="submit" className="w-full">{editKey ? "Сохранить" : "Добавить"}</Button>
          </form>
        </DialogContent>
      </Dialog>

      <AlertDialog open={!!deleteId} onOpenChange={(v) => { if (!v) setDeleteId(null); }}>
        <AlertDialogContent className="bg-card border-border">
          <AlertDialogHeader>
            <AlertDialogTitle className="flex items-center gap-2 text-foreground"><AlertTriangle className="w-5 h-5 text-destructive" /> Удалить ключ?</AlertDialogTitle>
            <AlertDialogDescription>Боты, использующие этот ключ, перестанут работать.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel className="border-border text-muted-foreground">Отмена</AlertDialogCancel>
            <AlertDialogAction onClick={() => deleteKey.mutate(deleteId)} className="bg-destructive text-destructive-foreground">Удалить</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
