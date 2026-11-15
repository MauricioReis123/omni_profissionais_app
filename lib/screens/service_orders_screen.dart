import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/service_order_model.dart';
import '../widgets/omni_ui.dart';

class ServiceOrdersScreen extends StatefulWidget {
  const ServiceOrdersScreen({super.key});

  @override
  State<ServiceOrdersScreen> createState() => _ServiceOrdersScreenState();
}

class _ServiceOrdersScreenState extends State<ServiceOrdersScreen> {
  String? _selectedOrderId;

  Color _statusColor(String status) {
    switch (status) {
      case 'em_execucao':
        return OmniTheme.neonGreen;
      case 'concluida':
      case 'contratada':
        return OmniTheme.alertEmerald;
      case 'aguardando_aprovacao':
        return const Color(0xFFC084FC);
      case 'em_revisao':
      case 'em_negociacao':
      case 'aguardando_documentos':
      case 'aguardando_pagamento':
        return OmniTheme.alertAmber;
      case 'cancelada':
      case 'suspensa':
      case 'em_disputa':
        return OmniTheme.alertCrimson;
      default:
        return OmniTheme.infoSky;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();
    if (state.orders.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma Ordem de Serviço ativa',
          style: TextStyle(color: OmniTheme.textSecondary),
        ),
      );
    }

    final selectedOrder = state.orders.firstWhere(
      (o) => o.ordemServicoId == _selectedOrderId,
      orElse: () => state.orders.first,
    );

    final statusColor = _statusColor(selectedOrder.status);
    final doneCount = selectedOrder.etapas.where((e) => e.concluida).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        OmniSectionHeader(
          icon: Icons.assignment_outlined,
          eyebrow: 'Sistema Operacional de Serviços (20 Status)',
          title: 'Ordens de Serviço (OS)',
          subtitle:
              'Ciclo completo de 20 status, marcos de execução, entregáveis com integridade e trilha de auditoria.',
          trailing: OmniBadge(text: '${state.orders.length} OS', glow: true),
        ),
        const SizedBox(height: 12),

        // Seletor Horizontal Fluido de Ordens de Serviço
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.orders.length,
            itemBuilder: (_, idx) {
              final ord = state.orders[idx];
              final isSelected =
                  ord.ordemServicoId == selectedOrder.ordemServicoId;
              final stColor = _statusColor(ord.status);
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedOrderId = ord.ordemServicoId),
                child: Container(
                  width: 256,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? OmniTheme.surfaceCardActive
                        : OmniTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? OmniTheme.neonGreen
                          : OmniTheme.borderSubtle,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow:
                        isSelected ? OmniTheme.neonGlow(opacity: 0.16) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ord.ordemServicoId,
                            style: monoStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          OmniBadge(text: ord.statusLabel, color: stColor),
                        ],
                      ),
                      Text(
                        ord.tituloServico,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prazo: ${ord.prazoFinal}',
                            style: monoStyle(
                                color: OmniTheme.textSecondary, fontSize: 10),
                          ),
                          Text(
                            formatBRL(ord.valorLiquido),
                            style: monoStyle(
                              color: OmniTheme.neonGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        // Painel Executivo da OS Selecionada
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedOrder.ordemServicoId,
                    style: monoStyle(
                      color: OmniTheme.neonGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  OmniBadge(
                      text: selectedOrder.statusLabel, color: statusColor),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                selectedOrder.tituloServico,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Cliente: ${selectedOrder.clienteNome}\nPrestador: ${selectedOrder.profissionalNome}',
                style: const TextStyle(
                    color: OmniTheme.textSecondary, fontSize: 11, height: 1.4),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: ServiceOrderModel.allStatusesLabels
                        .containsKey(selectedOrder.status)
                    ? selectedOrder.status
                    : 'em_execucao',
                dropdownColor: OmniTheme.surfaceCard,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Atualizar Status (Ciclo de 20 Status)',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: ServiceOrderModel.allStatusesLabels.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value,
                              style: const TextStyle(fontSize: 12)),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    state.updateOrderStatus(selectedOrder.ordemServicoId, val);
                    showOmniToast(
                      context,
                      'OS ${selectedOrder.ordemServicoId} atualizada para ${ServiceOrderModel.allStatusesLabels[val]}',
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      state.openOrderChat(selectedOrder.ordemServicoId),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: OmniTheme.neonGreen,
                    side: BorderSide(
                        color: OmniTheme.neonGreen.withOpacity(0.4)),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Abrir Chat Seguro desta OS'),
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: OmniTheme.surfaceInner,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OmniTheme.borderSubtle),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _finCol('CONTRATADO',
                        formatBRL(selectedOrder.valorContratado), Colors.white),
                    _finCol(
                        'TAXA (${state.commissionRate.toStringAsFixed(0)}%)',
                        formatBRL(selectedOrder.taxaPlataforma),
                        OmniTheme.textSecondary),
                    _finCol('LÍQUIDO', formatBRL(selectedOrder.valorLiquido),
                        OmniTheme.neonGreen),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Bloco 2: Marcos e Etapas
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: OmniTheme.neonGreen, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Marcos e Etapas',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Text(
                    '$doneCount de ${selectedOrder.etapas.length} concluídas',
                    style: monoStyle(
                        color: OmniTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...selectedOrder.etapas.map((etapa) {
                return GestureDetector(
                  onTap: () => state.toggleMilestone(
                      selectedOrder.ordemServicoId, etapa.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: etapa.concluida
                          ? const Color(0xFF0D1520)
                          : OmniTheme.surfaceInner,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: etapa.concluida
                            ? const Color(0xFF10B981).withOpacity(0.35)
                            : OmniTheme.borderSubtle,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          etapa.concluida
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: etapa.concluida
                              ? OmniTheme.neonGreen
                              : OmniTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                etapa.titulo,
                                style: TextStyle(
                                  color: etapa.concluida
                                      ? OmniTheme.textSecondary
                                      : Colors.white,
                                  fontSize: 12,
                                  decoration: etapa.concluida
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              Text(
                                etapa.concluida
                                    ? 'Concluído ${etapa.dataConclusao ?? ''}'
                                    : 'Pendente de execução (toque para marcar)',
                                style: monoStyle(
                                  color: etapa.concluida
                                      ? OmniTheme.alertEmerald
                                      : OmniTheme.alertAmber,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Bloco 3: Entregáveis Anexados
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified_user_outlined,
                          color: OmniTheme.neonGreen, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Entregáveis',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openUploadDeliverableDialog(
                        context, state, selectedOrder.ordemServicoId),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                    ),
                    icon: const Icon(Icons.upload_file, size: 14),
                    label:
                        const Text('Anexar', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (selectedOrder.entregaveis.isEmpty)
                const Text(
                  'Nenhum entregável anexado nesta Ordem de Serviço ainda.',
                  style:
                      TextStyle(color: OmniTheme.textSecondary, fontSize: 12),
                )
              else
                ...selectedOrder.entregaveis.map((del) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: OmniTheme.surfaceInner,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: OmniTheme.borderSubtle),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined,
                              color: OmniTheme.neonGreen, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  del.titulo,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${del.arquivoNome} · ${(del.tamanhoKb / 1024).toStringAsFixed(2)} MB',
                                  style: monoStyle(
                                      color: OmniTheme.textSecondary,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              OmniBadge(
                                text: del.status.toUpperCase(),
                                color: del.status == 'aprovado'
                                    ? OmniTheme.alertEmerald
                                    : OmniTheme.alertAmber,
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () => showOmniToast(
                                  context,
                                  'Download de ${del.arquivoNome} iniciado com verificação de hash.',
                                ),
                                child: Text(
                                  'Baixar',
                                  style: monoStyle(
                                    color: OmniTheme.neonGreen,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Bloco 4: Linha do Tempo
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.history, color: OmniTheme.neonGreen, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Linha do Tempo & Auditoria',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...selectedOrder.linhaTempo.map((ev) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: OmniTheme.neonGreen,
                            shape: BoxShape.circle,
                            boxShadow:
                                OmniTheme.neonGlow(opacity: 0.6, blur: 6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ev.data} · ${ev.usuario}',
                                style: monoStyle(
                                  color: OmniTheme.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                ev.evento,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _finCol(String label, String val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: monoStyle(color: OmniTheme.textSecondary, fontSize: 9),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: monoStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  void _openUploadDeliverableDialog(
      BuildContext context, OmniAppState state, String orderId) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OmniTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: OmniTheme.borderSubtle),
        ),
        title: const Text(
          'Anexar Entregável da OS',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: titleCtrl,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
            labelText: 'Título do Laudo / Petição / Comprovante',
            hintText: 'Ex: Laudo Pericial Homologado.pdf',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              state.uploadDeliverable(orderId, titleCtrl.text.trim());
              Navigator.pop(ctx);
              showOmniToast(context, 'Entregável salvo no cofre seguro da OS!');
            },
            child: const Text('Confirmar Envio'),
          ),
        ],
      ),
    );
  }
}
