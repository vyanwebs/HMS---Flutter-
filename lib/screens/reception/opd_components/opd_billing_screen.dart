import 'package:flutter/material.dart';

class OPDBillingScreen extends StatefulWidget {
  const OPDBillingScreen({super.key});

  @override
  State<OPDBillingScreen> createState() => _OPDBillingScreenState();
}

class _OPDBillingScreenState extends State<OPDBillingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<BillingItem> _billingItems = [];
  double _totalAmount = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _finalAmount = 0.0;

  final List<ServiceItem> _availableServices = [
    ServiceItem(name: 'Consultation Fee', category: 'Consultation', price: 500.0),
    ServiceItem(name: 'Blood Test', category: 'Lab Test', price: 300.0),
    ServiceItem(name: 'X-Ray', category: 'Diagnostics', price: 800.0),
    ServiceItem(name: 'ECG', category: 'Diagnostics', price: 600.0),
    ServiceItem(name: 'Urine Test', category: 'Lab Test', price: 200.0),
    ServiceItem(name: 'Dressing', category: 'Procedure', price: 150.0),
    ServiceItem(name: 'Injection', category: 'Procedure', price: 100.0),
    ServiceItem(name: 'Ultrasound', category: 'Diagnostics', price: 1200.0),
    ServiceItem(name: 'Medication', category: 'Pharmacy', price: 0.0),
    ServiceItem(name: 'Follow-up Visit', category: 'Consultation', price: 300.0),
  ];

  @override
  void initState() {
    super.initState();
    // Add some default items
    _billingItems.addAll([
      BillingItem(service: _availableServices[0], quantity: 1),
      BillingItem(service: _availableServices[1], quantity: 1),
    ]);
    _calculateTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OPD Billing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4299E1)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Color(0xFFED8936)),
            onPressed: _generateBill,
            tooltip: 'Print Bill',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search and Patient Info
            _buildPatientInfoCard(),

            const SizedBox(height: 20),

            // Billing Items
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available Services
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Color(0xFF718096), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Search services...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFFA0AEC0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: ListView.builder(
                              itemCount: _filteredServices.length,
                              itemBuilder: (context, index) {
                                final service = _filteredServices[index];
                                return ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(service.category).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(service.category),
                                      color: _getCategoryColor(service.category),
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    service.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${service.category} • ₹${service.price}',
                                    style: const TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () => _addService(service),
                                    icon: const Icon(Icons.add, size: 20, color: Color(0xFF48BB78)),
                                    tooltip: 'Add to Bill',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Bill Summary
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bill Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Billing Items Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF7FAFC),
                                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Service',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Price',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Qty',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Billing Items
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _billingItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _billingItems[index];
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: const Color(0xFFE2E8F0)),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.service.name,
                                                  style: const TextStyle(
                                                    color: Color(0xFF2D3748),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  item.service.category,
                                                  style: const TextStyle(
                                                    color: Color(0xFF718096),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '₹${item.service.price}',
                                              style: const TextStyle(
                                                color: Color(0xFF2D3748),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () => _decreaseQuantity(index),
                                                  icon: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFF56565).withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: const Icon(Icons.remove, size: 14, color: Color(0xFFF56565)),
                                                  ),
                                                ),
                                                Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    color: Color(0xFF2D3748),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () => _increaseQuantity(index),
                                                  icon: Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: const Icon(Icons.add, size: 14, color: Color(0xFF48BB78)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '₹${(item.service.price * item.quantity).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Color(0xFF2D3748),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () => _removeItem(index),
                                              icon: const Icon(Icons.delete, size: 18, color: Color(0xFFF56565)),
                                              tooltip: 'Remove',
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Total Calculation
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildAmountRow('Subtotal', '₹${_totalAmount.toStringAsFixed(2)}'),
                              const SizedBox(height: 10),
                              _buildAmountRow('Discount (₹)', '₹${_discount.toStringAsFixed(2)}'),
                              const SizedBox(height: 10),
                              _buildAmountRow('Tax (5%)', '₹${_tax.toStringAsFixed(2)}'),
                              const Divider(height: 30),
                              _buildAmountRow(
                                'Total Amount',
                                '₹${_finalAmount.toStringAsFixed(2)}',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Payment Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 15),
                              
                              // Discount Input
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Discount Amount (₹)',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.discount),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          _discount = double.tryParse(value) ?? 0.0;
                                          _calculateTotals();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Discount Percentage (%)',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.percent),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          final percent = double.tryParse(value) ?? 0.0;
                                          _discount = (_totalAmount * percent) / 100;
                                          _calculateTotals();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Payment Methods
                              const Text(
                                'Payment Method',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4A5568),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _buildPaymentMethodChip('Cash', Icons.money, true),
                                  _buildPaymentMethodChip('Credit Card', Icons.credit_card, false),
                                  _buildPaymentMethodChip('Debit Card', Icons.card_membership, false),
                                  _buildPaymentMethodChip('UPI', Icons.payment, false),
                                  _buildPaymentMethodChip('Insurance', Icons.medical_services, false),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _generateBill,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4299E1),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.receipt, size: 18),
                                          SizedBox(width: 8),
                                          Text('Generate Bill'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _processPayment,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF48BB78),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.payment, size: 18),
                                          SizedBox(width: 8),
                                          Text('Process Payment'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF4299E1),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'John Smith',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF48BB78).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Bill #OPD-2024-001',
                        style: TextStyle(
                          color: Color(0xFF48BB78),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _buildPatientInfoChip('Patient ID: P1001'),
                    const SizedBox(width: 10),
                    _buildPatientInfoChip('Age: 45 yrs'),
                    const SizedBox(width: 10),
                    _buildPatientInfoChip('Gender: Male'),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Dr. Sharma • Cardiology • Date: 2024-01-16',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _selectPatient,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.person_search, size: 18),
            label: const Text('Change Patient'),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4A5568),
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? const Color(0xFF2D3748) : const Color(0xFF718096),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? const Color(0xFF4299E1) : const Color(0xFF2D3748),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodChip(String method, IconData icon, bool selected) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(method),
        ],
      ),
      selected: selected,
      onSelected: (value) {
        // Handle payment method selection
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF4299E1),
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF4A5568),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? const Color(0xFF4299E1) : const Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  List<ServiceItem> get _filteredServices {
    if (_searchController.text.isEmpty) {
      return _availableServices;
    }
    final searchTerm = _searchController.text.toLowerCase();
    return _availableServices.where((service) =>
        service.name.toLowerCase().contains(searchTerm) ||
        service.category.toLowerCase().contains(searchTerm)).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Consultation':
        return const Color(0xFF4299E1);
      case 'Lab Test':
        return const Color(0xFF48BB78);
      case 'Diagnostics':
        return const Color(0xFFED8936);
      case 'Procedure':
        return const Color(0xFF9F7AEA);
      case 'Pharmacy':
        return const Color(0xFFF56565);
      default:
        return const Color(0xFF718096);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Consultation':
        return Icons.person;
      case 'Lab Test':
        return Icons.science;
      case 'Diagnostics':
        return Icons.monitor_heart;
      case 'Procedure':
        return Icons.medical_services;
      case 'Pharmacy':
        return Icons.local_pharmacy;
      default:
        return Icons.category;
    }
  }

  void _addService(ServiceItem service) {
    setState(() {
      // Check if service already exists
      final existingIndex = _billingItems.indexWhere((item) => item.service.name == service.name);
      if (existingIndex != -1) {
        _billingItems[existingIndex].quantity++;
      } else {
        _billingItems.add(BillingItem(service: service, quantity: 1));
      }
      _calculateTotals();
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      _billingItems[index].quantity++;
      _calculateTotals();
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_billingItems[index].quantity > 1) {
        _billingItems[index].quantity--;
      } else {
        _billingItems.removeAt(index);
      }
      _calculateTotals();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _billingItems.removeAt(index);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    _totalAmount = _billingItems.fold(
      0.0,
      (sum, item) => sum + (item.service.price * item.quantity),
    );
    _tax = (_totalAmount - _discount) * 0.05;
    _finalAmount = _totalAmount - _discount + _tax;
  }

  void _selectPatient() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Patient'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search patient by name or ID...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(3, (index) => ListTile(
                leading: const Icon(Icons.person, color: Color(0xFF4299E1)),
                title: Text(['John Smith', 'Michael Brown', 'Lisa Taylor'][index]),
                subtitle: Text(['P1001 • 45 yrs', 'P1002 • 32 yrs', 'P1003 • 42 yrs'][index]),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Patient selected'),
                      backgroundColor: Color(0xFF48BB78),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _generateBill() {
    if (_billingItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items in the bill'),
          backgroundColor: Color(0xFFF56565),
        ),
      );
      return;
    }

    final billId = 'OPD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill Generated'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bill has been generated successfully!'),
            const SizedBox(height: 10),
            Text('Bill ID: $billId'),
            const SizedBox(height: 10),
            Text('Total Amount: ₹${_finalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            _buildAmountRow('Subtotal', '₹${_totalAmount.toStringAsFixed(2)}'),
            _buildAmountRow('Discount', '-₹${_discount.toStringAsFixed(2)}'),
            _buildAmountRow('Tax (5%)', '₹${_tax.toStringAsFixed(2)}'),
            const Divider(),
            _buildAmountRow('Final Amount', '₹${_finalAmount.toStringAsFixed(2)}', isTotal: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _printBill();
            },
            child: const Text('Print Bill'),
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    if (_billingItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items to process payment'),
          backgroundColor: Color(0xFFF56565),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Process Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: ₹${_finalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount Paid (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Payment Reference',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.receipt),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment processed successfully'),
                  backgroundColor: Color(0xFF48BB78),
                ),
              );
            },
            child: const Text('Process Payment'),
          ),
        ],
      ),
    );
  }

  void _printBill() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bill sent to printer'),
        backgroundColor: Color(0xFFED8936),
      ),
    );
  }
}

class ServiceItem {
  final String name;
  final String category;
  final double price;

  ServiceItem({
    required this.name,
    required this.category,
    required this.price,
  });
}

class BillingItem {
  final ServiceItem service;
  int quantity;

  BillingItem({
    required this.service,
    required this.quantity,
  });
}