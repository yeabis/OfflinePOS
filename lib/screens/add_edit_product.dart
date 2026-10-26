import 'package:flutter/material.dart';
import '../core/database/pos_database.dart';
import '../core/database/db_schemas.dart'; 

class AddEditProductPage extends StatefulWidget {
  final Product? existingProduct; 

  const AddEditProductPage({super.key, this.existingProduct});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _barcodeController;
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _costController;
  late TextEditingController _minStockController;

  String _selectedCategory = 'Beverages';
  String _selectedUnit = 'Piece / EA';
  double _taxRate = 0.15; 
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(text: widget.existingProduct?.barcode ?? '');
    _titleController = TextEditingController(text: widget.existingProduct?.name ?? '');
    _priceController = TextEditingController(text: widget.existingProduct?.defaultPrice.toString() ?? '');
    _costController = TextEditingController(text: '0.00'); 
    _minStockController = TextEditingController(text: '10'); 
    
    if (widget.existingProduct != null) {
      _taxRate = widget.existingProduct!.taxRate;
    }

    _priceController.addListener(() => setState(() {}));
    _costController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _minStockController.dispose();
    super.dispose();
  }


  double get _marginPercent {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final cost = double.tryParse(_costController.text) ?? 0.0;
    if (price <= 0 || cost <= 0 || cost >= price) return 0.0;
    return ((price - cost) / price) * 100;
  }

  Future<void> _saveToSQLite() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text) ?? 0.0;
    final productId = widget.existingProduct?.id ?? 'prod_${DateTime.now().millisecondsSinceEpoch}';

    final product = Product(
      id: productId,
      barcode: _barcodeController.text.trim(),
      name: _titleController.text.trim(),
      defaultPrice: price,
      taxRate: _taxRate,
    );

    try {
      if (widget.existingProduct == null) {
        await PosDatabase.instance.createProduct(product);
      } else {
        await PosDatabase.instance.updateProduct(product);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Saved to SQLite successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.teal),
        );
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving: $e", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1326),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              
             
              _buildSectionContainer(
                child: Column(
                  children: [
                    _buildSectionTitle(Icons.qr_code_scanner, "Barcode / SKU", badge: "EAN-13 Valid"),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _barcodeController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF121617),
                        prefixIcon: const Icon(Icons.qr_code, color: Colors.white54),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 20),
                            const SizedBox(width: 8),
                            Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(8)),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, color: Colors.cyanAccent, size: 18),
                                onPressed: () {
                                },
                              ),
                            )
                          ],
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val!.isEmpty ? "Barcode required" : null,
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hardware scanner listener ready", style: TextStyle(color: Colors.white38, fontSize: 11)),
                        Text("sync::auto_vld", style: TextStyle(color: Colors.cyanAccent, fontSize: 11)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Product Title & Category
              _buildSectionContainer(
                child: Column(
                  children: [
                    _buildSectionTitle(Icons.label_outline, "Product Title", badge: "Default POS Label", badgeColor: Colors.transparent, badgeTextColor: Colors.white54),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF121617),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val!.isEmpty ? "Title required" : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildDropdown("Category", _selectedCategory, ['Beverages', 'Snacks', 'Stationery'])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDropdown("Unit of Measure", _selectedUnit, ['Piece / EA', 'Kg', 'Liter'])),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 3. Pricing & Margins
              _buildSectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle(Icons.payments_outlined, "Pricing & Margins"),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.cyanAccent, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up, color: Color(0xFF0B1326), size: 14),
                              const SizedBox(width: 4),
                              Text("${_marginPercent.toStringAsFixed(1)}% Margin", style: const TextStyle(color: Color(0xFF0B1326), fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildPriceField("defaultPrice", _priceController)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildPriceField("costPrice (COGS)", _costController)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Tax Configuration", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTaxBtn("15% Standard", 0.15)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTaxBtn("0% Zero", 0.0)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTaxBtn("Exempt", -1.0)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Inventory Policy
              _buildSectionContainer(
                child: Column(
                  children: [
                    _buildSectionTitle(Icons.inventory_2_outlined, "Inventory Policy", badge: "Local Ledger", badgeColor: Colors.transparent, badgeTextColor: Colors.cyanAccent),
                    const SizedBox(height: 16),
                    _buildInventoryRow("Min. Stock Alert", "Trigger reorder notification", _minStockController),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: const Color(0xFF121617), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Product Active", style: TextStyle(color: Colors.white, fontSize: 14)),
                              Text("Visible in terminal catalog", style: TextStyle(color: Colors.white54, fontSize: 11)),
                            ],
                          ),
                          Switch(
                            value: _isActive,
                            onChanged: (val) => setState(() => _isActive = val),
                            activeColor: Colors.cyanAccent,
                            activeTrackColor: Colors.cyan.withOpacity(0.3),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Actions
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CD7F6),
                  foregroundColor: const Color(0xFF0B1326),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveToSQLite,
                icon: const Icon(Icons.save),
                label: const Text("Save Product to SQLite", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: const Color(0xFF1E2738),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel Changes", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(6)),
            child: const Text("suk", style: TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          const Text("Ticket Line Item Details", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(backgroundColor: Colors.purple.shade200, radius: 14, child: const Icon(Icons.person, color: Colors.white, size: 18)),
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                const Text("SUK CATALOG ENGINE", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(12)),
              child: const Row(
                children: [
                  Icon(Icons.storage, color: Colors.white70, size: 12),
                  SizedBox(width: 4),
                  Text("SQLite Active", style: TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        const Text("Configure Item", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("createProduct & updateProduct Schema Input", style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2738),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, {String? badge, Color badgeColor = const Color(0xFF0B1326), Color badgeTextColor = Colors.white54}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
            child: Text(badge, style: TextStyle(color: badgeTextColor, fontSize: 10)),
          )
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFF121617), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E2738),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (String? newValue) {
              },
              items: items.map<DropdownMenuItem<String>>((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF121617),
            prefixText: "\$ ",
            prefixStyle: const TextStyle(color: Colors.cyanAccent, fontSize: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildTaxBtn(String label, double rate) {
    bool isSelected = _taxRate == rate;
    return InkWell(
      onTap: () => setState(() => _taxRate = rate),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyanAccent : const Color(0xFF121617),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? const Color(0xFF0B1326) : Colors.white70, 
            fontSize: 12, 
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          )
        ),
      ),
    );
  }

  Widget _buildInventoryRow(String title, String subtitle, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF121617), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Container(
            width: 80,
            decoration: BoxDecoration(color: const Color(0xFF1E2738), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 30,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const Text("units", style: TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }
}