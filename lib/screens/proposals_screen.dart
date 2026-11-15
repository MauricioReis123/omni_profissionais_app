import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/omni_models.dart';
import '../widgets/omni_ui.dart';

class ProposalsScreen extends StatefulWidget {
  const ProposalsScreen({super.key});

  @override
  State<ProposalsScreen> createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  String? _selectedProposalId;

  Color _statusColor(String status) {
    switch (status) {
      case 'em_negociacao':
        return OmniTheme.neonGreen;
      case 'aceita':
        return OmniTheme.alertEmerald;
      case 'recusada':
        return OmniTheme.alertCrimson;
      case 'enviada':
        return OmniTheme.alertAmber;
      default:
        return OmniTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();
    if (state.proposals.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma proposta enviada ainda.',
          style: TextStyle(color: OmniTheme.textSecondary, fontSize: 13),
        ),
      );
    }

    final selected = state.proposals.firstWhere(
      (p) => p.propostaId == _selectedProposalId,
      orElse: () => state.proposals.first,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        OmniSectionHeader(
          icon: Icons.layers_outlined,
          eyebrow: 'Módulo de Negociação',
          title: 'Minhas Propostas & Tramitações',
          subtitle:
              'Histórico completo de propostas comerciais enviadas, contrapropostas e contratos em formalização.',
          trailing: OmniBadge(
            text: '${state.proposals.length} Propostas',
            glow: true,
          ),
        ),
        const SizedBox(height: 12),

        // Seletor Horizontal Fluido de Propostas (estilo Coluna 1 do TSX)
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.proposals.length,
            itemBuilder: (_, idx) {
              final prop = state.proposals[idx];
              final isSelected = prop.propostaId == selected.propostaId;
              final stColor = _statusColor(prop.status);
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedProposalId = prop.propostaId),
                child: Container(
                  width: 245,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? OmniTheme.surfaceCardActive
                        : OmniTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? OmniTheme.neonGreen.withOpacity(0.65)
                          : OmniTheme.borderSubtle,
                      width: isSelected ? 1.4 : 1,
                    ),
                    boxShadow: isSelected ? OmniTheme.neonGlow(opacity: 0.14) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prop.propostaId,
                            style: monoStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          OmniBadge(
                            text: prop.status.replaceAll('_', ' ').toUpperCase(),
                            color: stColor,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prop.solicitacaoId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formatBRL(prop.valorTotal, decimals: true),
                            style: monoStyle(
                              color: OmniTheme.neonGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: OmniTheme.borderFaint),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Prazo: ${prop.prazoDias} dias',
                              style: monoStyle(
                                color: OmniTheme.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              prop.dataEnvio,
                              style: monoStyle(
                                color: OmniTheme.textSecondary,
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
            },
          ),
        ),
        const SizedBox(height: 14),

        // Painel Detalhado da Proposta Selecionada
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhamento da Proposta',
                          style: monoStyle(
                            color: OmniTheme.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selected.propostaId} · ${selected.solicitacaoId}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          selected.profissionalNome,
                          style: const TextStyle(
                            color: OmniTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'VALOR TOTAL',
                        style: monoStyle(
                          color: OmniTheme.textMuted,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        formatBRL(selected.valorTotal, decimals: true),
                        style: monoStyle(
                          color: OmniTheme.neonGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Decomposição Financeira 3 colunas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: OmniTheme.surfaceInner,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OmniTheme.borderFaint),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _decompCol(
                        'Honorários',
                        formatBRL(selected.valorHonorarios),
                      ),
                    ),
                    Expanded(
                      child: _decompCol(
                        'Desp. Adicionais',
                        formatBRL(selected.despesasAdicionais),
                      ),
                    ),
                    Expanded(
                      child: _decompCol(
                        'Custos Terceiros',
                        formatBRL(selected.custosTerceiros),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Escopo Técnico
              Text(
                'ESCOPO TÉCNICO & JUSTIFICATIVA',
                style: monoStyle(
                  color: OmniTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: OmniTheme.surfaceInner,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OmniTheme.borderFaint),
                ),
                child: Text(
                  selected.descricaoTrabalho,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Cronograma de Entregas & Marcos de Pagamento
              Text(
                'CRONOGRAMA DE ENTREGAS & MARCOS DE PAGAMENTO',
                style: monoStyle(
                  color: OmniTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              ...selected.etapas.asMap().entries.map((entry) {
                final idx = entry.key;
                final et = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInner,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OmniTheme.borderFaint),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '#${idx + 1}',
                        style: monoStyle(
                          color: OmniTheme.neonGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          et.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatBRL(et.valorProporcional),
                            style: monoStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${et.prazoDias} dias',
                            style: monoStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: OmniTheme.borderSubtle)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Validade: 15 dias · ${selected.condicoesPagamento}',
                      style: monoStyle(
                        color: OmniTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    if (selected.status != 'aceita' &&
                        selected.status != 'recusada') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  _openCounterProposalModal(context, state, selected),
                              child: const Text(
                                'Contraproposta',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                state.rejectProposal(selected.propostaId);
                                showOmniToast(
                                  context,
                                  'Proposta ${selected.propostaId} marcada como recusada.',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: OmniTheme.alertCrimson,
                                side: BorderSide(
                                  color: OmniTheme.alertCrimson.withOpacity(0.45),
                                ),
                              ),
                              child: const Text(
                                'Recusar',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: OmniTheme.neonGlow(opacity: 0.25, blur: 10),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final osId =
                                state.acceptProposal(selected.propostaId);
                            showOmniToast(
                              context,
                              'Proposta aceita! Ordem de Serviço $osId gerada com custódia.',
                            );
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text('Aceitar & Gerar Ordem de Serviço'),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 10),
                      OmniBadge(
                        text: selected.status == 'aceita'
                            ? 'CONVERTIDA EM ORDEM DE SERVIÇO'
                            : 'PROPOSTA RECUSADA',
                        color: _statusColor(selected.status),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _decompCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: monoStyle(color: OmniTheme.textMuted, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: monoStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _openCounterProposalModal(
      BuildContext context, OmniAppState state, ProposalModel prop) {
    final valCtrl =
        TextEditingController(text: (prop.valorTotal * 0.9).toStringAsFixed(0));
    final msgCtrl = TextEditingController(
      text:
          'Propomos readequação comercial dos honorários para alinhamento ao fluxo de caixa com pagamento em 2 parcelas.',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OmniTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: OmniTheme.borderSubtle),
        ),
        title: const Text(
          'Apresentar Contraproposta Comercial',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: valCtrl,
                keyboardType: TextInputType.number,
                style: monoStyle(color: Colors.white, fontSize: 13),
                decoration:
                    const InputDecoration(labelText: 'Novo Valor Proposto (R\$)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: const InputDecoration(
                    labelText: 'Justificativa Comercial'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final novoValor = double.tryParse(valCtrl.text) ?? prop.valorTotal;
              state.sendCounterProposal(
                  prop.propostaId, novoValor, msgCtrl.text.trim());
              Navigator.pop(ctx);
              showOmniToast(
                context,
                'Contraproposta de ${formatBRL(novoValor)} enviada para ${prop.propostaId}!',
              );
            },
            child: const Text('Enviar Contraproposta'),
          ),
        ],
      ),
    );
  }
}
