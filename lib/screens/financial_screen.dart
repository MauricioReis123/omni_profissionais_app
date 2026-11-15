import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../widgets/omni_ui.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  String _activeSubTab = 'transacoes';
  static const String _pixPayload =
      '00020126580014br.gov.bcb.pix0136omni-mp-chave-oficial-20265204000053039865405420005802BR5925OMNI MARKETPLACE GESTAO6009SAO PAULO62070503***6304E8A1';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    final totalBruto =
        state.transactions.fold<double>(0, (acc, t) => acc + t.valorBruto);
    final totalTaxas = state.transactions
        .fold<double>(0, (acc, t) => acc + t.taxaIntermediacao);
    final totalLiquido =
        state.transactions.fold<double>(0, (acc, t) => acc + t.valorLiquido);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        const OmniSectionHeader(
          icon: Icons.account_balance_wallet_outlined,
          eyebrow: 'Módulo Financeiro & Mercado Pago',
          title: 'Gestão Financeira, Custódia & Pix',
          subtitle:
              'Pix instantâneo, custódia segura de valores, repasses líquidos e planos de assinatura.',
        ),
        const SizedBox(height: 12),

        // Sub-abas Financeiras
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Row(
            children: [
              Expanded(child: _subTabBtn('transacoes', 'Extrato')),
              Expanded(child: _subTabBtn('planos', 'Planos')),
              Expanded(child: _subTabBtn('checkout_pix', 'Checkout Pix')),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _metricBox('BRUTO', formatBRL(totalBruto), Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _metricBox(
                  'TAXAS', formatBRL(totalTaxas), OmniTheme.textSecondary),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _metricBox(
                  'LÍQUIDO', formatBRL(totalLiquido), OmniTheme.neonGreen),
            ),
          ],
        ),
        const SizedBox(height: 14),

        if (_activeSubTab == 'transacoes') ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Liquidações Mercado Pago',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (state.orders.isNotEmpty) {
                    final first = state.orders.first;
                    state.simulatePixPayment(
                        first.ordemServicoId, first.valorContratado);
                    setState(() => _activeSubTab = 'checkout_pix');
                    showOmniToast(
                      context,
                      'Cobrança Pix gerada e confirmada via Webhook Mercado Pago!',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                ),
                icon: const Icon(Icons.qr_code_2, size: 15),
                label:
                    const Text('Simular Pix', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...state.transactions.map((tx) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: OmniTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: OmniTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tx.pagamentoId,
                          style: monoStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        OmniBadge(
                          text: tx.statusMercadoPago.toUpperCase(),
                          color: OmniTheme.alertEmerald,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'OS: ${tx.ordemServicoId} · ${tx.metodo.toUpperCase()} · ${tx.dataCriacao}',
                      style: monoStyle(
                          color: OmniTheme.textSecondary, fontSize: 10.5),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bruto: ${formatBRL(tx.valorBruto, decimals: true)}',
                          style: monoStyle(
                              color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          'Líquido: ${formatBRL(tx.valorLiquido, decimals: true)}',
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
              )),
        ],

        if (_activeSubTab == 'planos') ...[
          ...state.plans.map((plano) {
            final isSelected = plano.id == state.selectedPlanId;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isSelected
                    ? OmniTheme.surfaceCardActive
                    : OmniTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? OmniTheme.neonGreen
                      : OmniTheme.borderSubtle,
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected ? OmniTheme.neonGlow(opacity: 0.16) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plano.nome,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (plano.destaque)
                        const OmniBadge(text: 'DESTAQUE', glow: true),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plano.publicoAlvo,
                    style: const TextStyle(
                        color: OmniTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plano.precoMensal == 0
                            ? 'Grátis'
                            : '${formatBRL(plano.precoMensal)} /mês',
                        style: monoStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Comissão: ${plano.taxaComissaoPercentual}%',
                        style: monoStyle(
                          color: OmniTheme.neonGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...plano.recursos.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check,
                                size: 14, color: OmniTheme.neonGreen),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(r,
                                  style: const TextStyle(
                                      color: Color(0xFFCBD5E1), fontSize: 11)),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        state.selectPlan(plano.id);
                        showOmniToast(
                            context, 'Plano ${plano.nome} selecionado!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? OmniTheme.neonGreen
                            : const Color(0xFF1A2232),
                        foregroundColor:
                            isSelected ? Colors.black : Colors.white,
                      ),
                      child:
                          Text(isSelected ? 'Plano Ativo' : 'Contratar Plano'),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],

        if (_activeSubTab == 'checkout_pix') ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: OmniTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: OmniTheme.borderSubtle),
            ),
            child: Column(
              children: [
                const OmniBadge(
                  text: 'CUSTÓDIA SEGURA OMNI · BANCO CENTRAL',
                  icon: Icons.shield_outlined,
                  glow: true,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pagamento Pix Garantido',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Escaneie o QR Code ou utilize o código Copia e Cola abaixo.',
                  style:
                      TextStyle(color: OmniTheme.textSecondary, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: QrImageView(
                    data: _pixPayload,
                    version: QrVersions.auto,
                    size: 180.0,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInput,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OmniTheme.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Código Pix Copia e Cola:',
                        style: monoStyle(
                            color: OmniTheme.textSecondary, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _pixPayload,
                        style: monoStyle(
                            color: const Color(0xFFCBD5E1), fontSize: 10),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Clipboard.setData(
                                const ClipboardData(text: _pixPayload));
                            showOmniToast(context,
                                'Código Pix Copia e Cola copiado!');
                          },
                          icon: const Icon(Icons.copy, size: 15),
                          label: const Text('Copiar Código Pix'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _subTabBtn(String id, String label) {
    final active = _activeSubTab == id;
    return GestureDetector(
      onTap: () => setState(() => _activeSubTab = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF182236) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? OmniTheme.neonGreen : OmniTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _metricBox(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: OmniTheme.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: OmniTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: monoStyle(color: OmniTheme.textSecondary, fontSize: 9),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: monoStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
