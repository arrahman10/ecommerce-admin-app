// ================== Firebase Storage folder names ==================

/// Storage folder for original product images.
const String storageFolderProductImages = 'product_images';

/// Storage folder for resized product thumbnail images.
const String storageFolderProductThumbnails = 'product_thumbnails';

// ================== Purchase history field names ==================

/// Firestore field name for purchased quantity in a purchase history document.
const String purchaseFieldQuantity = 'quantity';

/// Firestore field name for purchase price per unit in a purchase history document.
const String purchaseFieldPurchasePrice = 'purchasePrice';

/// Firestore field name for the purchase date in a purchase history document.
const String purchaseFieldPurchaseDate = 'purchaseDate';

/// Firestore field name for an optional free-text note in a purchase history document.
const String purchaseFieldNote = 'note';
