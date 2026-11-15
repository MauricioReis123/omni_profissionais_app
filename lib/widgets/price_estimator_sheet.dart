import 'package:flutter/material.dart';
import '../core/theme/omni_theme.dart';
import 'omni_ui.dart';

void showPriceEstimatorSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _PriceEstimatorSheet(),
  );
}

class _PriceEstimatorSheet extends StatefulWidget {
  const _PriceEstimatorSheet();

  @override
  State<_PriceEstimatorSheet> createState() => _PriceEstimatorSheetState();
}

class _PriceEstimatorSheetState extends State<_PriceEstimatorSheet> {
  String _selectedService = 'tributario';
  String _porte = 'medio';
  String _urgencia = 'normal';

  static const Map<String, Map<String, dynamic>> _priceDatabase = {
    'tributario': {
      'nome': 'Defesa Fiscal / Transação Individual PGFN',
      'min': 22000.0,
      'max': 48000.0,
      'unidade': 'por processo / transação',
    },
    'cartorio': {
      'nome': 'Diligência Notarial & Registro de Imóveis',
      'min': 4500.0,
      'max': 9500.0,
      'unidade': 'por imóvel / matrícula',
    },
    'societario': {
      'nome': 'Reestruturação Societária & M&A',
      'min': 28000.0,
      'max': 65000.0,
      'unidade': 'por operação contratual',
    },
    'pericia': {
      'nome': 'Perícia Contábil & Auditoria SPED',
      'min': 12000.0,
      'max': 26000.0,
      'unidade': 'por laudo homologado',
    },
    'avaliacao': {
      'nome': 'Laudo Técnico de Avaliação Patrimonial (ABNT)',
      'min': 15000.0,
      'max': 32000.0,
      'unidade': 'por laudo com ART',
    },
  };

  @override
  Widget build(BuildContext context) {
    final item = _priceDatabase[_selectedService] ?? _priceDatabase['tributario']!;
    final multPorte =
        _porte == 'pequeno' ? 0.75 : (_porte == 'grande' ? 1.45 : 1.0);
    final multUrg = _urgencia == 'urgente' ? 1.25 : 1.0;

    final minCalc = (item['min'] as double) * multPorte * multUrg;
    final maxCalc = (item['max'] as double) * multPorte * multUrg;
    final moedasSugeridas =
        (_urgencia == 'urgente' ? 50 : 35) + (_porte == 'grande' ? 15 : 0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF0E131D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(top: BorderSide(color: OmniTheme.neonGreen, width: 1.5)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calculate,
                    color: OmniTheme.neonGreen, size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Guia de Preços & Calculadora GetNinjas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon:
                      const Icon(Icons.close, color: OmniTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedService,
              isExpanded: true,
              dropdownColor: OmniTheme.surfaceCard,
              decoration:
                  const InputDecoration(labelText: 'Selecione o Serviço'),
              items: _priceDatabase.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value['nome'] as String),
                      ))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedService = v ?? 'tributario'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _porte,
                    isExpanded: true,
                    dropdownColor: OmniTheme.surfaceCard,
                    decoration:
                        const InputDecoration(labelText: 'Porte da Demanda'),
                    items: const [
                      DropdownMenuItem(
                          value: 'pequeno',
                          child: Text('Pequeno Porte / Simplificado')),
                      DropdownMenuItem(
                          value: 'medio',
                          child: Text('Médio Porte / Padrão')),
                      DropdownMenuItem(
                          value: 'grande',
                          child: Text('Grande Porte / Complexo')),
                    ],
                    onChanged: (v) => setState(() => _porte = v ?? 'medio'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _urgencia,
                    isExpanded: true,
                    dropdownColor: OmniTheme.surfaceCard,
                    decoration: const InputDecoration(labelText: 'Urgência'),
                    items: const [
                      DropdownMenuItem(
                          value: 'normal',
                          child: Text('Prazo Normal (15 a 45d)')),
                      DropdownMenuItem(
                          value: 'urgente',
                          child: Text('Urgência Imediata (até 7d)')),
                    ],
                    onChanged: (v) => setState(() => _urgencia = v ?? 'normal'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF121C29),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: OmniTheme.neonGreen.withOpacity(0.35)),
              ),
              child: Column(
                children: [
                  Text(
                    'FAIXA DE PREÇO MÉDIO SUGERIDO',
                    style: monoStyle(
                      color: OmniTheme.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${formatBRL(minCalc)} – ${formatBRL(maxCalc)}',
                    style: monoStyle(
                      color: OmniTheme.neonGreen,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Valores praticados por homologados ${item['unidade']}',
                    style: monoStyle(
                        color: OmniTheme.textSecondary, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  OmniBadge(
                    text: 'Lead estimado: 🪙 $moedasSugeridas moedas',
                    color: OmniTheme.alertAmber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '* Base calculada a partir de centenas de contratações realizadas no ecossistema OMNI e referências de tabelas de classe (OAB, CRC, CREA).',
              style: TextStyle(
                  color: OmniTheme.textSecondary, fontSize: 11, height: 1.4),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
