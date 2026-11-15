import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../widgets/omni_ui.dart';
import '../widgets/coins_wallet_sheet.dart';
import '../widgets/client_request_sheet.dart';
import '../widgets/price_estimator_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _period = 'mes';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    final totalContratado =
        state.orders.fold<double>(0, (acc, o) => acc + o.valorContratado);
    final totalTaxas =
        state.orders.fold<double>(0, (acc, o) => acc + o.taxaPlataforma);
    final totalLiquido =
        state.orders.fold<double>(0, (acc, o) => acc + o.valorLiquido);
    final omniRecoveryCount =
        state.opportunities.where((o) => o.isOmniRecovery).length;

    final pendingMilestones = state.orders
        .expand((o) => o.etapas
            .where((e) => !e.concluida)
            .map((e) => {'etapa': e, 'os': o}))
        .take(3)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        // Hero Banner Executivo (1:1 com DashboardView.tsx)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D131F), Color(0xFF101726), Color(0xFF0D131F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt, size: 14, color: OmniTheme.neonGreen),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'PAINEL EXECUTIVO · ECOSSISTEMA OMNI · ${state.currentRole.toUpperCase()}',
                      style: monoStyle(
                        color: OmniTheme.neonGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Central de Gestão e Operações Profissionais',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Monitoramento inteligente de solicitações, moedas GetNinjas, propostas e ordens de serviço com custódia.',
                style: TextStyle(
                  color: OmniTheme.textSecondary,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _periodChip('mes', 'Mês Atual'),
                  const SizedBox(width: 6),
                  _periodChip('trimestre', 'Trimestre'),
                  const SizedBox(width: 6),
                  _periodChip('ano', 'Ano 2026'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Grid 2x2 de KPIs Financeiros e Operacionais
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.32,
          children: [
            _kpiCard(
              title: 'Faturamento Líquido',
              value: formatBRL(totalLiquido),
              subLeft: 'Bruto: ${formatBRL(totalContratado)}',
              subRight: 'Taxa: ${formatBRL(totalTaxas)}',
              icon: Icons.trending_up,
              onTap: () => state.setTab('financeiro'),
            ),
            _kpiCard(
              title: 'Oportunidades no Radar',
              value: '${state.opportunities.length}',
              subLeft: '$omniRecoveryCount OMNI Recup.',
              subRight: 'Explorar ->',
              highlightSubRight: true,
              icon: Icons.work_outline,
              onTap: () => state.setTab('oportunidades'),
            ),
            _kpiCard(
              title: 'Ordens de Serviço',
              value: '${state.orders.length}',
              subLeft: '20 status ativos',
              subRight: '100% no prazo',
              icon: Icons.assignment_turned_in_outlined,
              onTap: () => state.setTab('ordens_servico'),
            ),
            _kpiCard(
              title: 'Reputação OMNI',
              value: '4.96 / 5',
              subLeft: '48 avaliações',
              subRight: 'Resp: 18min',
              icon: Icons.star,
              iconColor: OmniTheme.alertAmber,
              onTap: () => state.setTab('documentos'),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Ações Rápidas Estilo GetNinjas
        Row(
          children: [
            Expanded(
              child: _quickActionBtn(
                icon: Icons.monetization_on,
                label: '${state.saldoMoedas} Moedas',
                sub: 'Recarregar',
                accent: OmniTheme.alertAmber,
                onTap: () => showCoinsWalletSheet(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _quickActionBtn(
                icon: Icons.add_circle_outline,
                label: 'Pedir Serviço',
                sub: 'Publicar Grátis',
                accent: OmniTheme.neonGreen,
                onTap: () => showClientRequestSheet(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _quickActionBtn(
                icon: Icons.calculate_outlined,
                label: 'Preços',
                sub: 'Calculadora',
                accent: OmniTheme.infoSky,
                onTap: () => showPriceEstimatorSheet(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Oportunidades em Destaque
        Container(
          padding: const EdgeInsets.all(14),
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
                      Icon(Icons.work_outline,
                          color: OmniTheme.neonGreen, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Oportunidades em Destaque',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => state.setTab('oportunidades'),
                    child: Text(
                      'Ver todas (${state.opportunities.length})',
                      style: const TextStyle(
                        color: OmniTheme.neonGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...state.opportunities.take(3).map((opp) {
                final unlocked =
                    state.unlockedLeads.containsKey(opp.solicitacaoId);
                return GestureDetector(
                  onTap: () => state.setTab('oportunidades'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: OmniTheme.surfaceInner,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: opp.isOmniRecovery
                            ? OmniTheme.neonGreen.withOpacity(0.32)
                            : OmniTheme.borderSubtle,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              opp.solicitacaoId,
                              style: monoStyle(
                                color: OmniTheme.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                            Row(
                              children: [
                                if (unlocked)
                                  const OmniBadge(
                                    text: 'LIBERADO',
                                    color: OmniTheme.alertEmerald,
                                  )
                                else
                                  OmniBadge(
                                    text: '🪙 ${opp.custoMoedas}',
                                    color: OmniTheme.alertAmber,
                                  ),
                                const SizedBox(width: 6),
                                OmniBadge(
                                  text: 'Match ${opp.compatibilidadeScore}%',
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (opp.isOmniRecovery) ...[
                          const SizedBox(height: 6),
                          const OmniBadge(
                            text: 'SOLICITAÇÃO OMNI — RECUPERAÇÃO EMPRESARIAL',
                            glow: true,
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          opp.titulo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '📍 ${opp.cidade}/${opp.estado} · ${opp.prazoEstimadoDias}d',
                              style: const TextStyle(
                                color: OmniTheme.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '${formatBRL(opp.orcamentoMin)} - ${formatBRL(opp.orcamentoMax)}',
                              style: monoStyle(
                                color: OmniTheme.neonGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Prazos & Entregáveis + Credenciamento
        Container(
          padding: const EdgeInsets.all(14),
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
                      Icon(Icons.calendar_today,
                          color: OmniTheme.neonGreen, size: 15),
                      SizedBox(width: 6),
                      Text(
                        'Prazos & Entregáveis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Próximos 15 dias',
                    style: monoStyle(
                      color: OmniTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...pendingMilestones.map((item) {
                final os = item['os'] as dynamic;
                final etapa = item['etapa'] as dynamic;
                return GestureDetector(
                  onTap: () => state.setTab('ordens_servico'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: OmniTheme.surfaceInner,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: OmniTheme.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              os.ordemServicoId,
                              style: monoStyle(
                                color: OmniTheme.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              'Prazo: ${os.prazoFinal}',
                              style: monoStyle(
                                color: OmniTheme.alertAmber,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          etapa.titulo,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cliente: ${os.clienteNome}',
                          style: const TextStyle(
                              color: OmniTheme.textSecondary, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1421),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: OmniTheme.neonGreen.withOpacity(0.3)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user,
                        color: OmniTheme.neonGreen, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credenciamento Profissional Ativo',
                            style: TextStyle(
                              color: OmniTheme.neonGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Documentação homologada pela comissão técnica OMNI. Apto a liberar leads e propor em demandas tributárias e cíveis.',
                            style: TextStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _periodChip(String id, String label) {
    final active = _period == id;
    return GestureDetector(
      onTap: () => setState(() => _period = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF182236) : OmniTheme.surfaceInput,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? OmniTheme.neonGreen.withOpacity(0.5)
                : OmniTheme.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? OmniTheme.neonGreen : OmniTheme.textSecondary,
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _kpiCard({
    required String title,
    required String value,
    required String subLeft,
    required String subRight,
    required IconData icon,
    Color iconColor = OmniTheme.neonGreen,
    bool highlightSubRight = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: OmniTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: OmniTheme.borderSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: OmniTheme.textSecondary,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(icon, size: 15, color: iconColor),
              ],
            ),
            Text(
              value,
              style: monoStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              padding: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFF1A2232))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subLeft,
                      style: monoStyle(
                        color: OmniTheme.textSecondary,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    subRight,
                    style: monoStyle(
                      color: highlightSubRight
                          ? OmniTheme.neonGreen
                          : OmniTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickActionBtn({
    required IconData icon,
    required String label,
    required String sub,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: OmniTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Icon(icon, color: accent, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              sub,
              style: monoStyle(color: accent, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
