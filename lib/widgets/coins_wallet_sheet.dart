import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/omni_models.dart';
import 'omni_ui.dart';

void showCoinsWalletSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _CoinsWalletSheet(),
  );
}

class _CoinsWalletSheet extends StatefulWidget {
  const _CoinsWalletSheet();

  @override
  State<_CoinsWalletSheet> createState() => _CoinsWalletSheetState();
}

class _CoinsWalletSheetState extends State<_CoinsWalletSheet> {
  String _activeTab = 'comprar';
  String _paymentMethod = 'pix';
  late CoinPackageModel _selectedPackage;

  @override
  void initState() {
    super.initState();
    final state = context.read<OmniAppState>();
    _selectedPackage = state.coinPackages.length > 1
        ? state.coinPackages[1]
        : state.coinPackages.first;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0E131D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          border: Border(top: BorderSide(color: OmniTheme.neonGreen, width: 1.5)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(18),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: OmniTheme.amberGlow(opacity: 0.35, blur: 12),
                  ),
                  child: const Center(
                    child: Icon(Icons.monetization_on,
                        color: Colors.black, size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARTEIRA DE MOEDAS OMNI · ESTILO GETNINJAS',
                        style: monoStyle(
                          color: OmniTheme.neonGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Moedas & Desbloqueio de Leads',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close, color: OmniTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card de Saldo Atual
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF121A28),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: OmniTheme.alertAmber.withOpacity(0.45)),
                boxShadow: OmniTheme.amberGlow(opacity: 0.12, blur: 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saldo Atual Disponível',
                            style: monoStyle(
                                color: OmniTheme.textSecondary, fontSize: 11),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${state.saldoMoedas}',
                                style: monoStyle(
                                  color: OmniTheme.alertAmber,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'MOEDAS OMNI',
                                style: monoStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: OmniTheme.backgroundBlack,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: OmniTheme.borderSubtle),
                        ),
                        child: Row(
                          children: [
                            _tabBtn('comprar', 'Comprar'),
                            _tabBtn('extrato', 'Histórico'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.verified_user,
                          size: 14, color: OmniTheme.neonGreen),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Garantia Ninja: Moedas estornadas caso o cliente não responda em 48h.',
                          style: TextStyle(
                              color: OmniTheme.textSecondary, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_activeTab == 'comprar') ...[
              const Text(
                'Escolha seu pacote de moedas para liberar contatos diretos:',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...state.coinPackages.map((pack) {
                final isSelected = pack.id == _selectedPackage.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPackage = pack),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF131D2C)
                          : OmniTheme.surfaceInput,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? OmniTheme.neonGreen
                            : OmniTheme.borderSubtle,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? OmniTheme.neonGlow(opacity: 0.16, blur: 12)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      pack.nome,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (pack.popular) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: OmniTheme.neonGreen,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'MAIS VENDIDO',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '${pack.totalMoedas} moedas',
                                    style: monoStyle(
                                      color: OmniTheme.alertAmber,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  if (pack.bonusMoedas > 0) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      '+${pack.bonusMoedas} bônus',
                                      style: const TextStyle(
                                        color: OmniTheme.alertEmerald,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                'Apenas R\$ ${pack.custoPorMoeda.toStringAsFixed(2)} por moeda',
                                style: monoStyle(
                                    color: OmniTheme.textSecondary,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatBRL(pack.precoReais, decimals: true),
                              style: monoStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? OmniTheme.neonGreen
                                  : OmniTheme.textSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Text(
                'Forma de Pagamento:',
                style: monoStyle(color: OmniTheme.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _payBtn('pix', Icons.qr_code_2, 'Pix Instantâneo'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _payBtn('cartao', Icons.credit_card, 'Cartão'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: OmniTheme.neonGlow(opacity: 0.25, blur: 12),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final added =
                        state.buyCoinPackage(_selectedPackage, _paymentMethod);
                    Navigator.pop(context);
                    showOmniToast(
                      context,
                      'Recarga confirmada! +$added moedas adicionadas à sua carteira.',
                    );
                  },
                  icon: const Icon(Icons.bolt, size: 18),
                  label: Text(
                    'Recarregar ${_selectedPackage.totalMoedas} Moedas (${formatBRL(_selectedPackage.precoReais)})',
                  ),
                ),
              ),
            ] else ...[
              const Text(
                'Histórico de Moedas (Recargas, Desbloqueios e Estornos):',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...state.coinHistory.map((tx) {
                final isPositive = tx.quantidadeMoedas >= 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInput,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OmniTheme.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.descricao,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tx.data} · Saldo após: ${tx.saldoApos} moedas',
                              style: monoStyle(
                                color: OmniTheme.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isPositive ? '+' : ''}${tx.quantidadeMoedas}',
                        style: monoStyle(
                          color: isPositive
                              ? OmniTheme.alertEmerald
                              : OmniTheme.alertAmber,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String id, String label) {
    final active = _activeTab == id;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF182336) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
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

  Widget _payBtn(String id, IconData icon, String label) {
    final active = _paymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF131D2C) : OmniTheme.surfaceInput,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? OmniTheme.neonGreen : OmniTheme.borderSubtle,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: active ? OmniTheme.neonGreen : OmniTheme.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : OmniTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
