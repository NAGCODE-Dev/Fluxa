class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wjqpnntgdhwygvgthgxi.supabase.co',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_QkdpaTFY-eLoXwH_AZjJHA_uxKSGoiP',
  );

  static const redirectScheme = String.fromEnvironment(
    'SUPABASE_REDIRECT_SCHEME',
    defaultValue: 'financas',
  );

  static const redirectHost = String.fromEnvironment(
    'SUPABASE_REDIRECT_HOST',
    defaultValue: 'login-callback',
  );

  static String get redirectTo => '$redirectScheme://$redirectHost/';
}
