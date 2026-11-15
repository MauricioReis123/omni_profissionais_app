import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/omni_models.dart';
import '../models/opportunity_model.dart';
import '../widgets/omni_ui.dart';
import '../widgets/coins_wallet_sheet.dart';
import '../widgets/client_request_sheet.dart';
import '../widgets/price_estimator_sheet.dart';

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
  String _searchTerm = '';
  String _selectedCategory = 'todos';
  String _selectedOrigin = 'todos';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    final filtered = state.opportunities.where((opp) {
      final q = _searchTerm.toLowerCase();
      final matchesSearch = q.isEmpty ||
          opp.titulo.toLowerCase().contains(q) ||
          opp.descricaoResumida.toLowerCase().contains(q) ||
          opp.cidade.toLowerCase().contains(q) ||
          opp.especialidade.toLowerCase().contains(q);
      final matchesCategory =
          _selectedCategory == 'todos' || opp.categoria == _selectedCategory;
      final matchesOrigin =
          _selectedOrigin == 'todos' || opp.origemSolicitacao == _selectedOrigin;
      return matchesSearch && matchesCategory && matchesOrigin;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        OmniSectionHeader(
          icon: Icons.work_outline,
          eyebrow: 'Módulo de Intermediação & Leads GetNinjas',
          title: 'OPORTUNIDADES DE TRABALHO',
          subtitle:
              'Pedidos de clientes e empresas em recuperação. Desbloqueie contatos com moedas ou apresente proposta técnica direta.',
          trailing: GestureDetector(
            onTap: () => showCoinsWalletSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF121C29),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: OmniTheme.alertAmber.withOpacity(0.5)),
                boxShadow: OmniTheme.amberGlow(opacity: 0.16, blur: 10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪙 ', style: TextStyle(fontSize: 12)),
                  Text(
                    '${state.saldoMoedas}',
                    style: monoStyle(
                      color: OmniTheme.alertAmber,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Barra de Ações Rápidas GetNinjas
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => showPriceEstimatorSheet(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: OmniTheme.borderSubtle),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                ),
                icon: const Icon(Icons.calculate_outlined,
                    size: 16, color: OmniTheme.neonGreen),
                label: const Text('Guia de Preços',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: OmniTheme.neonGlow(opacity: 0.22, blur: 10),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => showClientRequestSheet(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text('Solicitar Serviço',
                      style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Busca e Filtros
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            children: [
              TextField(
                onChanged: (v) => setState(() => _searchTerm = v),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Buscar por título, cidade ou especialidade...',
                  prefixIcon: Icon(Icons.search,
                      color: OmniTheme.textSecondary, size: 18),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _filterChip('todos', 'Todas Áreas'),
                    _filterChip('contabil_tributario', 'Contábil & Fiscal'),
                    _filterChip('juridico', 'Jurídico'),
                    _filterChip('cartorario_notarial', 'Cartórios'),
                    _filterChip('engenharia_arquitetura', 'Engenharia'),
                    _filterChip('administracao_gestao', 'Gestão'),
                    _filterChip('financeiro', 'Financeiro'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedOrigin,
                dropdownColor: OmniTheme.surfaceCard,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'todos', child: Text('Todas as Origens')),
                  DropdownMenuItem(
                      value: 'omni_recuperacao_empresarial',
                      child: Text('OMNI Recuperação Empresarial')),
                  DropdownMenuItem(
                      value: 'marketplace_publico',
                      child: Text('Marketplace Público')),
                  DropdownMenuItem(
                      value: 'solicitacao_direta',
                      child: Text('Solicitação Direta')),
                ],
                onChanged: (v) => setState(() => _selectedOrigin = v ?? 'todos'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: OmniTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OmniTheme.borderSubtle),
            ),
            child: const Column(
              children: [
                Text(
                  'Nenhuma oportunidade encontrada',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Ajuste os filtros de categoria e origem para ver mais pedidos.',
                  style:
                      TextStyle(color: OmniTheme.textSecondary, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...filtered.map((opp) => _buildOpportunityCard(context, state, opp)),
      ],
    );
  }

  Widget _filterChip(String id, String label) {
    final active = _selectedCategory == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = id),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? OmniTheme.neonGreen.withOpacity(0.15)
              : OmniTheme.surfaceInput,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? OmniTheme.neonGreen : OmniTheme.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? OmniTheme.neonGreen : OmniTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(
      BuildContext context, OmniAppState state, OpportunityModel opp) {
    final unlocked = state.unlockedLeads[opp.solicitacaoId];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: OmniTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: opp.isOmniRecovery
              ? OmniTheme.neonGreen.withOpacity(0.4)
              : OmniTheme.borderSubtle,
        ),
        boxShadow:
            opp.isOmniRecovery ? OmniTheme.neonGlow(opacity: 0.1, blur: 12) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  opp.solicitacaoId,
                  style: monoStyle(
                    color: OmniTheme.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OmniBadge(
                  text:
                      'Restam ${opp.vagasRestantes} de ${opp.maxProfissionaisPermitidos}',
                  color: OmniTheme.alertAmber,
                ),
              ),
              const SizedBox(width: 6),
              OmniBadge(
                text: 'Match ${opp.compatibilidadeScore}%',
              ),
            ],
          ),
          if (opp.isOmniRecovery) ...[
            const SizedBox(height: 8),
            const OmniBadge(
              text: 'SOLICITAÇÃO OMNI — RECUPERAÇÃO EMPRESARIAL',
              glow: true,
            ),
          ],
          const SizedBox(height: 10),
          Text(
            opp.titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${opp.subcategoria} · ${opp.especialidade}',
            style: TextStyle(
              color: OmniTheme.neonGreen.withOpacity(0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opp.descricaoResumida,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          if (unlocked != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1713),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: const Color(0xFF10B981).withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: OmniTheme.alertEmerald, size: 16),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Contato do Cliente Liberado!',
                          style: TextStyle(
                            color: OmniTheme.alertEmerald,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${unlocked.moedasGastas} moedas',
                        style: monoStyle(
                          color: OmniTheme.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    unlocked.clienteNome,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📞 ${unlocked.clienteTelefone} · ✉️ ${unlocked.clienteEmail}',
                    style: monoStyle(
                        color: const Color(0xFFE2E8F0), fontSize: 10.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '📍 ${unlocked.enderecoCompleto}',
                    style: const TextStyle(
                        color: OmniTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: unlocked.clienteWhatsapp));
                            showOmniToast(
                              context,
                              'WhatsApp ${unlocked.clienteTelefone} copiado! Abra o WhatsApp para iniciar atendimento.',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          icon: const Icon(Icons.chat, size: 15),
                          label: const Text('Chamar WhatsApp',
                              style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          final estorno =
                              state.requestLeadRefund(opp.solicitacaoId);
                          showOmniToast(
                            context,
                            'Garantia Ninja: +$estorno moedas estornadas para sua carteira!',
                          );
                        },
                        icon: const Icon(Icons.rotate_left,
                            size: 14, color: OmniTheme.alertAmber),
                        label: const Text(
                          'Pedir Estorno',
                          style: TextStyle(
                            color: OmniTheme.alertAmber,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: OmniTheme.surfaceInner,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: OmniTheme.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline,
                      size: 16, color: OmniTheme.alertAmber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Contato Protegido: ${opp.clienteNomeAnonimizado}. Libere para ver WhatsApp e telefone.',
                      style: const TextStyle(
                          color: OmniTheme.textSecondary, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '🪙 ${opp.custoMoedas}',
                    style: monoStyle(
                      color: OmniTheme.alertAmber,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child:
                    _paramItem('LOCALIZAÇÃO', '${opp.cidade}/${opp.estado}'),
              ),
              Expanded(
                child: _paramItem(
                    'QUANDO PRECISA', opp.quandoPrecisa ?? 'Nos próximos dias',
                    color: OmniTheme.alertAmber),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _paramItem('PRAZO ESTIMADO',
                    '${opp.prazoEstimadoDias} dias (${opp.modalidade})'),
              ),
              Expanded(
                child: _paramItem(
                  'ORÇAMENTO ESTIMADO',
                  '${formatBRL(opp.orcamentoMin)} - ${formatBRL(opp.orcamentoMax)}',
                  color: OmniTheme.neonGreen,
                  monoVal: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: opp.documentosExigidos
                .map((req) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        req,
                        style: monoStyle(
                            color: const Color(0xFFCBD5E1), fontSize: 10),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),

          Column(
            children: [
              if (unlocked == null) ...[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: OmniTheme.amberGlow(opacity: 0.25, blur: 10),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final ok =
                          state.unlockLead(opp.solicitacaoId, opp.custoMoedas);
                      if (ok) {
                        showOmniToast(
                          context,
                          'Contato liberado! ${opp.custoMoedas} moedas debitadas.',
                        );
                      } else {
                        showOmniToast(
                          context,
                          'Saldo insuficiente (${state.saldoMoedas} moedas). Recarregue seu pacote!',
                        );
                        showCoinsWalletSheet(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OmniTheme.alertAmber,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.lock_open, size: 16),
                    label: Text(
                        'Liberar Contato (${opp.custoMoedas} Moedas)'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: OmniTheme.neonGlow(opacity: 0.22, blur: 10),
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _openProposalModal(context, state, opp),
                  icon: const Icon(Icons.send, size: 15),
                  label: const Text('Apresentar Proposta Técnica'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _paramItem(String label, String value,
      {Color color = Colors.white, bool monoVal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: monoStyle(
            color: OmniTheme.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: monoVal
              ? monoStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                )
              : TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _openProposalModal(
      BuildContext context, OmniAppState state, OpportunityModel opp) {
    final sugerido = ((opp.orcamentoMin + opp.orcamentoMax) / 2).round();
    final honCtrl = TextEditingController(text: sugerido.toString());
    final despCtrl = TextEditingController(text: '1500');
    final tercCtrl = TextEditingController(text: '0');
    final prazoCtrl =
        TextEditingController(text: opp.prazoEstimadoDias.toString());
    final descCtrl = TextEditingController(
      text:
          'Apresentamos nossa proposta técnica para atender à demanda de ${opp.especialidade}, observando rigorosamente as normas vigentes, prazos legais e os objetivos de soerguimento empresarial da demandante.',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (ctx, setModalState) {
                final hon = double.tryParse(honCtrl.text) ?? 0;
                final desp = double.tryParse(despCtrl.text) ?? 0;
                final terc = double.tryParse(tercCtrl.text) ?? 0;
                final total = hon + desp + terc;

                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E131D),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                    border: Border(
                      top: BorderSide(color: OmniTheme.neonGreen, width: 1.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Puxador visual do modal (indica que pode arrastar para baixo)
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Cabeçalho fixo
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'APRESENTAÇÃO DE PROPOSTA · ${opp.solicitacaoId}',
                                    style: monoStyle(
                                      color: OmniTheme.neonGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    opp.titulo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(Icons.close,
                                  color: OmniTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: OmniTheme.borderSubtle),

                      // Conteúdo rolável vinculado ao gesto de arrastar e scroll
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(18),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: honCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => setModalState(() {}),
                                    decoration: const InputDecoration(
                                        labelText: 'Honorários (R\$)'),
                                    style: monoStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: despCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => setModalState(() {}),
                                    decoration: const InputDecoration(
                                        labelText: 'Despesas (R\$)'),
                                    style: monoStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: tercCtrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => setModalState(() {}),
                                    decoration: const InputDecoration(
                                        labelText: 'Terceiros (R\$)'),
                                    style: monoStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: prazoCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Prazo (dias)'),
                                    style: monoStyle(color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: OmniTheme.surfaceInner,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: OmniTheme.borderFaint),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Valor Total Proposto:',
                                    style: monoStyle(
                                        color: OmniTheme.textSecondary, fontSize: 11),
                                  ),
                                  Text(
                                    formatBRL(total, decimals: true),
                                    style: monoStyle(
                                      color: OmniTheme.neonGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  descCtrl.text =
                                      'PLANO TÉCNICO DE ATUAÇÃO ESTRUTURADA:\n1. Diagnóstico Preliminar: Exame minucioso da documentação para subsidiar a estratégia de ${opp.especialidade}.\n2. Execução Operacional: Confecção das peças fundamentadas e requerimentos.\n3. Acompanhamento & Compliance no cofre seguro OMNI.';
                                },
                                icon: const Icon(Icons.auto_awesome,
                                    size: 15, color: OmniTheme.neonGreen),
                                label: const Text(
                                  'Apoio de IA na Redação',
                                  style: TextStyle(
                                      color: OmniTheme.neonGreen, fontSize: 11),
                                ),
                              ),
                            ),
                            TextField(
                              controller: descCtrl,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                  labelText: 'Descrição do Trabalho & Escopo'),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      // Botão Fixo no Rodapé (Nunca cortado e visível)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E131D),
                          border: Border(
                            top: BorderSide(color: OmniTheme.borderSubtle),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final h = double.tryParse(honCtrl.text) ?? 25000;
                              final d = double.tryParse(despCtrl.text) ?? 1500;
                              final t = double.tryParse(tercCtrl.text) ?? 0;
                              final prazo = int.tryParse(prazoCtrl.text) ?? 30;
                              final tot = h + d + t;
                              final propId =
                                  'PROP-${DateTime.now().millisecondsSinceEpoch % 900000 + 100000}';
                              state.submitProposal(
                                ProposalModel(
                                  propostaId: propId,
                                  solicitacaoId: opp.solicitacaoId,
                                  profissionalId: 'PRO-1001',
                                  profissionalNome: 'Dra. Helena Vasconcelos',
                                  valorHonorarios: h,
                                  despesasAdicionais: d,
                                  custosTerceiros: t,
                                  valorTotal: tot,
                                  descricaoTrabalho: descCtrl.text,
                                  etapas: [
                                    ProposalStepModel(
                                        titulo:
                                            'Auditoria documental e análise preliminar',
                                        prazoDias: 7,
                                        valorProporcional: tot * 0.25),
                                    ProposalStepModel(
                                        titulo:
                                            'Elaboração e protocolo da peça técnica',
                                        prazoDias: (prazo - 12).clamp(1, 365),
                                        valorProporcional: tot * 0.45),
                                    ProposalStepModel(
                                        titulo:
                                            'Conclusão e entrega dos comprovantes',
                                        prazoDias: 5,
                                        valorProporcional: tot * 0.30),
                                  ],
                                  prazoDias: prazo,
                                  condicoesPagamento:
                                      'Custódia Mercado Pago OMNI com liberação por etapas',
                                  documentosNecessarios: opp.documentosExigidos,
                                  dataEnvio: 'Hoje',
                                  status: 'enviada',
                                ),
                              );
                              Navigator.pop(ctx);
                              showOmniToast(
                                context,
                                'Proposta $propId enviada com sucesso!',
                              );
                            },
                            icon: const Icon(Icons.send, size: 16),
                            label: const Text('Transmitir Proposta Oficial'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}