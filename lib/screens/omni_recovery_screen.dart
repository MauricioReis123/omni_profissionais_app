import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../widgets/omni_ui.dart';

class OmniRecoveryScreen extends StatefulWidget {
  const OmniRecoveryScreen({super.key});

  @override
  State<OmniRecoveryScreen> createState() => _OmniRecoveryScreenState();
}

class _OmniRecoveryScreenState extends State<OmniRecoveryScreen> {
  String? _selectedCaseId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();
    if (state.recoveryCases.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum caso em reestruturação ativo.',
          style: TextStyle(color: OmniTheme.textSecondary),
        ),
      );
    }

    final selectedCase = state.recoveryCases.firstWhere(
      (c) => c.casoEmpresarialId == _selectedCaseId,
      orElse: () => state.recoveryCases.first,
    );

    final caseOpportunities = state.opportunities
        .where((o) => o.casoEmpresarialId == selectedCase.casoEmpresarialId)
        .toList();

    final payloadJson = const JsonEncoder.withIndent('  ').convert({
      'caso_empresarial_id': selectedCase.casoEmpresarialId,
      'empresa_cnpj': selectedCase.empresaCnpj,
      'origem_solicitacao': 'omni_recuperacao_empresarial',
      'passivo_total': selectedCase.passivoTotal,
      'solicitacoes_geradas': selectedCase.solicitacoesGeradas,
      'status_liberacao_financeira': 'garantida_custodia_omni',
      'timestamp': DateTime.now().toIso8601String(),
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        OmniSectionHeader(
          icon: Icons.apartment,
          eyebrow: 'Arquitetura de Integração',
          title: 'OMNI Recuperação Empresarial',
          subtitle:
              'Rastreamento de casos em crise, desdobramento multidisciplinar e compartilhamento de IDs universais.',
          trailing: OmniBadge(
            text: '${state.recoveryCases.length} Casos',
            glow: true,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: OmniTheme.neonGlow(opacity: 0.25, blur: 12),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              final casoId = state.dispatchNewRecoveryCase();
              setState(() => _selectedCaseId = casoId);
              showOmniToast(
                context,
                'Caso $casoId integrado! 2 solicitações publicadas no Marketplace.',
              );
            },
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Simular Despacho de Novo Caso'),
          ),
        ),
        const SizedBox(height: 14),

        Text(
          'CASOS ATIVOS EM REESTRUTURAÇÃO',
          style: monoStyle(
            color: OmniTheme.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // Seletor Horizontal de Casos Empresariais
        SizedBox(
          height: 122,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.recoveryCases.length,
            itemBuilder: (_, idx) {
              final c = state.recoveryCases[idx];
              final isSelected =
                  c.casoEmpresarialId == selectedCase.casoEmpresarialId;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedCaseId = c.casoEmpresarialId),
                child: Container(
                  width: 265,
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
                    boxShadow:
                        isSelected ? OmniTheme.neonGlow(opacity: 0.14) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c.casoEmpresarialId,
                            style: monoStyle(
                              color: OmniTheme.neonGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            c.statusRecuperacao.replaceAll('_', ' '),
                            style: monoStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.empresaRazaoSocial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'CNPJ: ${c.empresaCnpj} · ${c.cidade}/${c.estado}',
                            style: monoStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Passivo: R\$ ${(c.passivoTotal / 1000000).toStringAsFixed(1)}M',
                            style: monoStyle(
                              color: OmniTheme.alertCrimson,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${c.solicitacoesGeradas.length} OS geradas',
                            style: monoStyle(
                              color: OmniTheme.textSecondary,
                              fontSize: 10.5,
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

        // Bloco 1: Dossiê da Empresa em Recuperação
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
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    selectedCase.casoEmpresarialId,
                    style: monoStyle(
                      color: OmniTheme.neonGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const OmniBadge(
                    text: 'TRIAGEM MULTIDISCIPLINAR CONCLUÍDA',
                    color: OmniTheme.alertEmerald,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                selectedCase.empresaRazaoSocial,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                'CNPJ: ${selectedCase.empresaCnpj} · Sede: ${selectedCase.cidade}/${selectedCase.estado}',
                style: monoStyle(color: OmniTheme.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: OmniTheme.surfaceInner,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FATURAMENTO/ANO',
                              style: monoStyle(
                                  color: OmniTheme.textMuted, fontSize: 9)),
                          const SizedBox(height: 2),
                          Text(
                            formatBRL(selectedCase.faturamentoAnualEstimado),
                            style: monoStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: OmniTheme.surfaceInner,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PASSIVO TOTAL',
                              style: monoStyle(
                                  color: OmniTheme.textMuted, fontSize: 9)),
                          const SizedBox(height: 2),
                          Text(
                            formatBRL(selectedCase.passivoTotal),
                            style: monoStyle(
                              color: OmniTheme.alertCrimson,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'ÁREAS QUE DEMANDAM PRESTADORES ESPECIALIZADOS:',
                style: monoStyle(color: OmniTheme.textSecondary, fontSize: 10),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: selectedCase.areasAfetadas
                    .map((a) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: OmniTheme.borderSubtle),
                          ),
                          child: Text(
                            a,
                            style: const TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Bloco 2: Ordens de Serviço Originadas Deste Caso
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
                  const Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.layers_outlined,
                            color: OmniTheme.neonGreen, size: 16),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Ordens Originadas Deste Caso',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${caseOpportunities.length} ativa(s)',
                    style:
                        monoStyle(color: OmniTheme.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (caseOpportunities.isEmpty)
                const Text(
                  'As solicitações deste caso já foram convertidas ou aguardam despacho no radar.',
                  style: TextStyle(color: OmniTheme.textSecondary, fontSize: 12),
                )
              else
                ...caseOpportunities.map((opp) => GestureDetector(
                      onTap: () => state.setTab('oportunidades'),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: OmniTheme.surfaceInner,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: OmniTheme.borderFaint),
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
                                    color: OmniTheme.neonGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const OmniBadge(
                                  text: 'LIBERAÇÃO GARANTIDA',
                                  color: OmniTheme.alertEmerald,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              opp.titulo,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              opp.descricaoResumida,
                              style: const TextStyle(
                                  color: OmniTheme.textSecondary, fontSize: 11.5),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  opp.categoria.replaceAll('_', ' '),
                                  style: monoStyle(
                                      color: OmniTheme.textMuted, fontSize: 10),
                                ),
                                Text(
                                  '${formatBRL(opp.orcamentoMin)} - ${formatBRL(opp.orcamentoMax)}',
                                  style: monoStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Bloco 3: Terminal JSON Payload API REST
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceInner,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal,
                          size: 14, color: OmniTheme.neonGreen),
                      const SizedBox(width: 6),
                      Text(
                        'Payload API REST',
                        style: monoStyle(
                          color: OmniTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: payloadJson));
                      showOmniToast(
                          context, 'Payload JSON copiado para área de transferência!');
                    },
                    child: Text(
                      'COPIAR JSON',
                      style: monoStyle(
                        color: OmniTheme.neonGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'POST /api/v1/integracao/recuperacao-empresarial',
                style: monoStyle(color: OmniTheme.alertEmerald, fontSize: 10),
              ),
              const Divider(color: OmniTheme.borderFaint, height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Text(
                  payloadJson,
                  style: monoStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
