import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/omni_models.dart';
import '../widgets/omni_ui.dart';

class JobsBoardScreen extends StatefulWidget {
  const JobsBoardScreen({super.key});

  @override
  State<JobsBoardScreen> createState() => _JobsBoardScreenState();
}

class _JobsBoardScreenState extends State<JobsBoardScreen> {
  String _searchTerm = '';
  String _selectedType = 'todos';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();

    final filtered = state.jobPostings.where((j) {
      final q = _searchTerm.toLowerCase();
      final matchSearch = q.isEmpty ||
          j.titulo.toLowerCase().contains(q) ||
          j.empresaNome.toLowerCase().contains(q) ||
          j.cidade.toLowerCase().contains(q);
      final matchType =
          _selectedType == 'todos' || j.tipoContrato == _selectedType;
      return matchSearch && matchType;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        OmniSectionHeader(
          icon: Icons.badge_outlined,
          eyebrow: 'Mural de Oportunidades Fixas & Recorrentes',
          title: 'Vagas PJ, Freelancer Fixo & CLT',
          subtitle:
              'Colocação profissional e parcerias corporativas contínuas para advogados, contadores e consultores.',
          trailing: OmniBadge(
            text: '${state.jobPostings.length} Vagas',
            glow: true,
          ),
        ),
        const SizedBox(height: 12),
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
                  hintText: 'Buscar por cargo, empresa ou cidade...',
                  prefixIcon: Icon(Icons.search,
                      color: OmniTheme.textSecondary, size: 18),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: OmniTheme.surfaceCard,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'todos',
                      child: Text('Todos os Tipos de Contrato')),
                  DropdownMenuItem(
                      value: 'pj', child: Text('Contrato PJ (Pessoa Jurídica)')),
                  DropdownMenuItem(
                      value: 'freelancer_fixo',
                      child: Text('Freelancer Fixo / Recorrente')),
                  DropdownMenuItem(
                      value: 'associado', child: Text('Sócio / Associado')),
                  DropdownMenuItem(
                      value: 'clt_especialista',
                      child: Text('CLT Especialista')),
                ],
                onChanged: (v) => setState(() => _selectedType = v ?? 'todos'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...filtered.map((job) {
          final isApplied = state.appliedJobIds.contains(job.vagaId);
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      job.vagaId,
                      style: monoStyle(
                          color: OmniTheme.textSecondary, fontSize: 10),
                    ),
                    OmniBadge(
                      text: job.contractLabel,
                      color: Colors.white70,
                    ),
                    OmniBadge(text: job.modalidade.toUpperCase()),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  job.titulo,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '🏢 ${job.empresaNome} · 📍 ${job.cidade}/${job.estado}',
                  style: const TextStyle(
                      color: OmniTheme.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInput,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: OmniTheme.borderSubtle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REMUNERAÇÃO ESTIMADA',
                              style: monoStyle(
                                  color: OmniTheme.textSecondary, fontSize: 9),
                            ),
                            Text(
                              job.remuneracaoEstimada,
                              style: monoStyle(
                                color: OmniTheme.neonGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${job.totalCandidatos} candidatos',
                        style: monoStyle(
                            color: OmniTheme.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  job.descricaoAtividades,
                  style: const TextStyle(
                      color: Color(0xFFCBD5E1), fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: OmniTheme.backgroundBlack,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: OmniTheme.borderFaint),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Requisitos:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      ...job.requisitos.map((r) => Text('• $r',
                          style: const TextStyle(
                              color: OmniTheme.textSecondary, fontSize: 11))),
                      if (job.beneficios.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Benefícios:',
                            style: TextStyle(
                                color: OmniTheme.neonGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        ...job.beneficios.map((b) => Text('✓ $b',
                            style: const TextStyle(
                                color: OmniTheme.textSecondary, fontSize: 11))),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: isApplied
                      ? OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.check_circle,
                              color: OmniTheme.alertEmerald, size: 16),
                          label: const Text(
                            'Candidatura Enviada!',
                            style: TextStyle(color: OmniTheme.alertEmerald),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:
                                OmniTheme.neonGlow(opacity: 0.2, blur: 10),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _openApplyDialog(context, state, job),
                            icon: const Icon(Icons.send, size: 15),
                            label: const Text('Candidatar-se à Vaga (1 Clique)'),
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _openApplyDialog(
      BuildContext context, OmniAppState state, JobPostingModel job) {
    final msgCtrl = TextEditingController(
      text:
          'Prezada equipe da ${job.empresaNome}, possuo registro profissional homologado no ecossistema OMNI e sólida experiência para atuar como ${job.titulo}.',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OmniTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: OmniTheme.borderSubtle),
        ),
        title: Text(
          'Candidatar-se: ${job.titulo}',
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: msgCtrl,
          maxLines: 4,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
              labelText: 'Carta de Apresentação Rápida'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              state.applyToJob(job.vagaId);
              Navigator.pop(ctx);
              showOmniToast(
                context,
                'Candidatura enviada! A empresa contratante receberá seu perfil.',
              );
            },
            child: const Text('Enviar Candidatura'),
          ),
        ],
      ),
    );
  }
}
