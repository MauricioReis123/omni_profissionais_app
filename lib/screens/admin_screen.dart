import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../widgets/omni_ui.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String _activeTab = 'cadastros';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        const OmniSectionHeader(
          icon: Icons.admin_panel_settings_outlined,
          eyebrow: 'Módulo de Governança Master',
          title: 'Painel Administrativo OMNI',
          subtitle:
              'Controle de cadastros profissionais, catálogo expansível de serviços e taxas de intermediação.',
        ),
        const SizedBox(height: 12),

        // Sub-abas Administrativas (Moderação, Catálogo Universal, Taxas)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: OmniTheme.borderSubtle),
          ),
          child: Row(
            children: [
              Expanded(child: _tabBtn('cadastros', 'Moderação')),
              Expanded(child: _tabBtn('catalogo', 'Catálogo')),
              Expanded(child: _tabBtn('taxas', 'Taxas & Regras')),
            ],
          ),
        ),
        const SizedBox(height: 14),

        if (_activeTab == 'cadastros') ...[
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
                      child: Text(
                        'Fila de Homologação Documental',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    Text(
                      '${state.documents.length} em fila',
                      style: monoStyle(
                          color: OmniTheme.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...state.documents.map((doc) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: OmniTheme.surfaceInner,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: OmniTheme.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  doc.titulo,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              OmniBadge(
                                text: doc.statusVerificacao
                                    .replaceAll('_', ' ')
                                    .toUpperCase(),
                                color: doc.statusVerificacao == 'aprovado'
                                    ? OmniTheme.alertEmerald
                                    : (doc.statusVerificacao == 'rejeitado'
                                        ? OmniTheme.alertCrimson
                                        : OmniTheme.alertAmber),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${doc.documentoId} · ${doc.nomeArquivo} · ${doc.dataUpload}',
                            style: monoStyle(
                                color: OmniTheme.textSecondary, fontSize: 10),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    state.moderateDocument(
                                        doc.documentoId, 'rejeitado');
                                    showOmniToast(
                                        context,
                                        'Documento ${doc.documentoId} rejeitado.');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: OmniTheme.alertCrimson,
                                    side: BorderSide(
                                        color: OmniTheme.alertCrimson
                                            .withOpacity(0.45)),
                                  ),
                                  icon: const Icon(Icons.close, size: 14),
                                  label: const Text('Rejeitar',
                                      style: TextStyle(fontSize: 11)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    state.moderateDocument(
                                        doc.documentoId, 'aprovado');
                                    showOmniToast(
                                        context,
                                        'Documento ${doc.documentoId} homologado!');
                                  },
                                  icon: const Icon(Icons.check, size: 14),
                                  label: const Text('Aprovar',
                                      style: TextStyle(fontSize: 11)),
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
        ],

        if (_activeTab == 'catalogo') ...[
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Catálogo Universal de Serviços',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Categorias expansíveis dinamicamente sem recompilar o app.',
                            style: TextStyle(
                                color: OmniTheme.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openAddCategoryDialog(context, state),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Nova', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...state.catalogCategories.map((cat) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: OmniTheme.surfaceInner,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: OmniTheme.borderFaint),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat.nome,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Código: ${cat.slug} · ${cat.especialidades} especialidades ativas',
                                  style: monoStyle(
                                      color: OmniTheme.textSecondary,
                                      fontSize: 10.5),
                                ),
                              ],
                            ),
                          ),
                          OmniBadge(
                            text: cat.status.toUpperCase(),
                            color: OmniTheme.alertEmerald,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],

        if (_activeTab == 'taxas') ...[
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
                      child: Text(
                        'Taxa de Intermediação Padrão (%)',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      '${state.commissionRate.toStringAsFixed(1)}%',
                      style: monoStyle(
                        color: OmniTheme.neonGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: state.commissionRate,
                  min: 5.0,
                  max: 20.0,
                  divisions: 30,
                  activeColor: OmniTheme.neonGreen,
                  onChanged: (val) => state.updateCommissionRate(val),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInner,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: OmniTheme.borderFaint),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• Atos notariais de cartórios permanecem isentos de comissão comercial por exigência legal do CNJ.',
                        style: TextStyle(
                            color: OmniTheme.textSecondary,
                            fontSize: 11,
                            height: 1.4),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Assinantes dos planos Profissional e Empresarial possuem taxas reduzidas diferenciadas.',
                        style: TextStyle(
                            color: OmniTheme.textSecondary,
                            fontSize: 11,
                            height: 1.4),
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

  Widget _tabBtn(String id, String label) {
    final active = _activeTab == id;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = id),
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

  void _openAddCategoryDialog(BuildContext context, OmniAppState state) {
    final nameCtrl = TextEditingController();
    final slugCtrl = TextEditingController();
    final espCtrl = TextEditingController(text: '6');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OmniTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: OmniTheme.borderSubtle),
        ),
        title: const Text(
          'Nova Categoria Universal',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration:
                  const InputDecoration(labelText: 'Nome da Categoria'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: slugCtrl,
              style: monoStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(
                  labelText: 'Slug (ex: auditoria_esg)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: espCtrl,
              keyboardType: TextInputType.number,
              style: monoStyle(color: Colors.white, fontSize: 12),
              decoration:
                  const InputDecoration(labelText: 'Qtd. Especialidades'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              final slug = slugCtrl.text.trim().isEmpty
                  ? nameCtrl.text
                      .trim()
                      .toLowerCase()
                      .replaceAll(RegExp(r'\s+'), '_')
                  : slugCtrl.text.trim();
              final esp = int.tryParse(espCtrl.text) ?? 5;
              state.addCatalogCategory(nameCtrl.text.trim(), slug, esp);
              Navigator.pop(ctx);
              showOmniToast(
                  context, 'Categoria "${nameCtrl.text.trim()}" adicionada!');
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
