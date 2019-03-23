final _msgs = {
  'language': {
    'en_US': 'Language',
    'es_ES': 'Idioma',
    'gl_ES': 'Linguaxe',
    'ca_CA': 'Llingua',
    'cn_CN': '语言',
  },
  'options': {
    'en_US': 'Options',
    'es_ES': 'Opciones',
    'gl_ES': 'Opcións',
    'ca_CA': 'Opcions',
    'cn_CN': '选项',
  },
  'invalid_qr': {
    'en_US': 'Invalid QR code.',
    'es_ES': 'Código QR inválido.',
    'gl_ES': 'Código QR inválido.',
    'ca_CA': 'Codi QR no vàlid.',
    'cn_CN': 'QR码无效',
  },
  'invalid_restaurant': {
    'en_US': 'Restaurant not found.',
    'es_ES': 'Restaurante no encontrado.',
    'gl_ES': 'Restaurante non atopado.',
    'ca_CA': 'Restaurant no trobat.',
    'cn_CN': '找不到餐馆',
  },
  'allergens': {
    'en_US': 'Allergens:',
    'es_ES': 'Alérgenos:',
    'gl_ES': 'Alérxenos:',
    'ca_CA': 'Al·lèrgens:',
    'cn_CN': '过敏原',
  },
  'allergen_egg': {
    'en_US': 'Eggs',
    'es_ES': 'Huevos',
    'gl_ES': 'Ovo',
    'ca_CA': 'Ous',
    'cn_CN': '鸡蛋',
  },
  'allergen_gluten': {
    'en_US': 'Gluten',
    'es_ES': 'Gluten',
    'gl_ES': 'Glute',
    'ca_CA': 'Gluten',
    'cn_CN': '面筋',
  },
  'allergen_lactose': {
    'en_US': 'Lactose',
    'es_ES': 'Lactosa',
    'gl_ES': 'Lactosa',
    'ca_CA': 'Lactosa',
    'cn_CN': '乳糖',
  },
  'comments': {
    'en_US': 'Comments',
    'es_ES': 'Comentarios',
    'gl_ES': 'Comentarios',
    'ca_CA': 'Comentaris',
    'cn_CN': '评论',
  },
};

String formatCurrency(dynamic amount, String currency) {
  switch (currency) {
    case 'eur':
      return '$amount€';
      break;
    case 'gbp':
      return '£$amount';
    case 'usd':
    case 'aud':
    case 'cad':
      return '\$$amount';
    case 'yen':
    case 'cny':
      return '￥$amount';
  }
  return 'ERROR';
}

String formatMessage(String lang, String str) {
  return (_msgs[str] ?? {})[lang] ?? 'TRANSLATION ERROR "$lang" "$str"';
}
