import 'package:diary/app/app_state.dart';
import 'package:diary/app/i18n.dart';
import 'package:diary/data/models/webdav_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) {
      return;
    }
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(context, zh: '无法打开链接', en: 'Cannot open link')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      children: [
        ListTile(
          leading: const Icon(Icons.cleaning_services_outlined),
          title: Text(tr(context, zh: '清理附件缓存', en: 'Clear Attachment Cache')),
          subtitle: Text(
            tr(
              context,
              zh: '删除本地已同步附件，需要时会从 WebDAV 重新拉取',
              en: 'Delete synced local files and re-download from WebDAV when needed',
            ),
          ),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(tr(context, zh: '清理缓存', en: 'Clear Cache')),
                  content: Text(
                    tr(
                      context,
                      zh: '将删除本地已同步附件的原图文件，缩略图会保留。是否继续？',
                      en: 'Original synced files will be removed and thumbnails kept. Continue?',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(tr(context, zh: '取消', en: 'Cancel')),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(tr(context, zh: '清理', en: 'Clear')),
                    ),
                  ],
                );
              },
            );
            if (confirmed != true || !context.mounted) {
              return;
            }
            final removed = await context
                .read<DiaryAppState>()
                .clearSyncedAttachmentCache();
            if (!context.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  tr(
                    context,
                    zh: '已清理 $removed 个附件缓存文件',
                    en: 'Cleared $removed cached attachment files',
                  ),
                ),
              ),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.cloud_outlined),
          title: Text(tr(context, zh: 'WebDAV 设置', en: 'WebDAV')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const WebDavSettingsPage()),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(tr(context, zh: '外观', en: 'Appearance')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AppearanceSettingsPage()),
            );
          },
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(tr(context, zh: '关于项目', en: 'About Project')),
          subtitle: Text(
            tr(context, zh: '打开 GitHub 项目主页', en: 'Open GitHub project page'),
          ),
          trailing: const Icon(Icons.open_in_new),
          onTap: () =>
              _openLink(context, 'https://github.com/kid-depress/Dav_Diary'),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.support_agent),
          title: Text(tr(context, zh: '联系作者', en: 'Contact Author')),
          subtitle: Text(tr(context, zh: '加入交流群', en: 'Join Group')),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openLink(
            context,
            'https://qun.qq.com/universal-share/share?ac=1&authKey=OwDtxNxyG47DX3WMUDnu91lAyFdkzIU613RHHxCVWrAs2iL15plLPUnpyj95SfjM&busi_data=eyJncm91cENvZGUiOiIxMDkxMTI1NDk1IiwidG9rZW4iOiJjMmM1d2FVMzNOd0NyaXVEeThGR2NjZFdNMVhZKzRpbzlhZ3krQS9lWWY2MzFnOUlGa1plRFErUHVwNW9NUUZ0IiwidWluIjoiMzQ2ODk0MzM2NyJ9&data=pg995AanOfOHor1w9a0u6DhsRI9j991Z3W8kmfoPzum9XTgpaJlgnyU8gCjJ2y-TP6KEkaKxRh1VkEECMt7Hug&svctype=4&tempid=h5_group_info',
          ),
        ),
      ],
    );
  }
}

class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, zh: '外观', en: 'Appearance')),
      ),
      body: Consumer<DiaryAppState>(
        builder: (context, appState, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(context, zh: '主题', en: 'Theme'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(tr(context, zh: '跟随系统', en: 'System')),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(tr(context, zh: '浅色', en: 'Light')),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(tr(context, zh: '深色', en: 'Dark')),
                    ),
                  ],
                  selected: {appState.themeMode},
                  onSelectionChanged: (selection) {
                    appState.setThemeMode(selection.first);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  tr(context, zh: '语言', en: 'Language'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'zh_CN', label: Text('中文')),
                    ButtonSegment(value: 'en_US', label: Text('English')),
                  ],
                  selected: {
                    appState.locale.languageCode == 'en' ? 'en_US' : 'zh_CN',
                  },
                  onSelectionChanged: (selection) {
                    final code = selection.first;
                    if (code == 'en_US') {
                      appState.setLocale(const Locale('en', 'US'));
                    } else {
                      appState.setLocale(const Locale('zh', 'CN'));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WebDavSettingsPage extends StatefulWidget {
  const WebDavSettingsPage({super.key});

  @override
  State<WebDavSettingsPage> createState() => _WebDavSettingsPageState();
}

class _WebDavSettingsPageState extends State<WebDavSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  final _remoteDirController = TextEditingController();

  bool _loaded = false;
  bool _obscurePassword = true;
  ConflictStrategy _conflictStrategy = ConflictStrategy.lastWriteWins;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) {
      return;
    }
    final appState = context.read<DiaryAppState>();
    final config = appState.webDavConfig;
    _urlController.text = config.serverUrl;
    _userController.text = config.username;
    _passwordController.text = config.password;
    _remoteDirController.text = config.remoteDir;
    _conflictStrategy = config.conflictStrategy;
    _loaded = true;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _remoteDirController.dispose();
    super.dispose();
  }

  Future<bool> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    final appState = context.read<DiaryAppState>();
    final messenger = ScaffoldMessenger.of(context);
    final config = WebDavConfig(
      serverUrl: _urlController.text.trim(),
      username: _userController.text.trim(),
      password: _passwordController.text.trim(),
      remoteDir: _remoteDirController.text.trim().isEmpty
          ? '/diary'
          : _remoteDirController.text.trim(),
      conflictStrategy: _conflictStrategy,
    );
    await appState.updateWebDavConfig(config);
    if (!mounted) {
      return false;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(tr(context, zh: '配置已保存', en: 'Saved')),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, zh: 'WebDAV 设置', en: 'WebDAV')),
      ),
      body: Consumer<DiaryAppState>(
        builder: (context, appState, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: tr(context, zh: '服务器地址', en: 'Server URL'),
                        hintText: 'https://dav.example.com',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? tr(context, zh: '必填', en: 'Required')
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: tr(context, zh: '用户名', en: 'Username'),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? tr(context, zh: '必填', en: 'Required')
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: tr(context, zh: '密码', en: 'Password'),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? tr(context, zh: '必填', en: 'Required')
                          : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _remoteDirController,
                      decoration: InputDecoration(
                        labelText: tr(context, zh: '远端目录', en: 'Remote Dir'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<ConflictStrategy>(
                      initialValue: _conflictStrategy,
                      decoration: InputDecoration(
                        labelText: tr(
                          context,
                          zh: '冲突策略',
                          en: 'Conflict Strategy',
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: ConflictStrategy.lastWriteWins,
                          child: Text(
                            tr(context, zh: '最后修改者优先', en: 'Last Write Wins'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: ConflictStrategy.keepBoth,
                          child: Text(
                            tr(context, zh: '保留两个副本', en: 'Keep Both'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _conflictStrategy = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (appState.lastSyncAt != null)
                Text(
                  tr(context, zh: '上次同步：', en: 'Last sync: ') +
                      DateFormat(
                        'yyyy-MM-dd HH:mm',
                      ).format(appState.lastSyncAt!),
                ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _saveConfig,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(tr(context, zh: '保存', en: 'Save')),
                  ),
                  OutlinedButton.icon(
                    onPressed: appState.syncing
                        ? null
                        : () async {
                            final okToContinue = await _saveConfig();
                            if (!okToContinue || !context.mounted) {
                              return;
                            }
                            try {
                              final ok = await appState.testWebDavConnection();
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? tr(
                                            context,
                                            zh: '连接成功',
                                            en: 'Connected',
                                          )
                                        : tr(
                                            context,
                                            zh: '连接失败',
                                            en: 'Failed to connect',
                                          ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${tr(context, zh: '连接失败：', en: 'Connection failed: ')}$e',
                                  ),
                                ),
                              );
                            }
                          },
                    icon: const Icon(Icons.network_check_outlined),
                    label: Text(tr(context, zh: '测试连接', en: 'Test')),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: appState.syncing
                        ? null
                        : () async {
                            final okToContinue = await _saveConfig();
                            if (!okToContinue || !context.mounted) {
                              return;
                            }
                            final result = await appState.syncNow();
                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${result.message} ${tr(context, zh: '上传', en: 'up')}:${result.uploaded} ${tr(context, zh: '下载', en: 'down')}:${result.downloaded} ${tr(context, zh: '冲突', en: 'conflicts')}:${result.conflicts}',
                                ),
                              ),
                            );
                          },
                    icon: appState.syncing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    label: Text(
                      appState.syncing
                          ? tr(context, zh: '同步中...', en: 'Syncing...')
                          : tr(context, zh: '立即同步', en: 'Sync now'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
