// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _editiedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageURL': '',
  };

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editiedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editiedProduct.title,
          'description': _editiedProduct.description,
          'price': _editiedProduct.price.toString(),
          'imageURL': '',
        };
        _imageURLController.text = _editiedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editiedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editiedProduct.id, _editiedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editiedProduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text(
                    'An error occurred!',
                  ),
                  content: Text(
                    "something went wrong!!!!",
                  ),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
        // } finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // }

      } 
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please add title';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (val) {
                        _editiedProduct = Product(
                            id: _editiedProduct.id,
                            isFavorite: _editiedProduct.isFavorite,
                            title: val,
                            description: _editiedProduct.description,
                            price: _editiedProduct.price,
                            imageUrl: _editiedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Field can\'t be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price Should be greater than 0';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editiedProduct = Product(
                            id: _editiedProduct.id,
                            isFavorite: _editiedProduct.isFavorite,
                            title: _editiedProduct.title,
                            description: _editiedProduct.description,
                            price: double.parse(val),
                            imageUrl: _editiedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLength: 30,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter description';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 character long.';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editiedProduct = Product(
                            id: _editiedProduct.id,
                            isFavorite: _editiedProduct.isFavorite,
                            title: _editiedProduct.title,
                            description: val,
                            price: _editiedProduct.price,
                            imageUrl: _editiedProduct.imageUrl);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _imageURLController.text.isEmpty
                              ? Text('Enter Valid URL')
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: FittedBox(
                                    child: Image.network(
                                      _imageURLController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            //initialValue: _initValues['imageURL'],
                            decoration: InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageURLController,
                            focusNode: _imageURLFocusNode,
                            onFieldSubmitted: (_) => _saveForm,
                            validator: (value) {
                              if (value.isEmpty) //kk.com
                              {
                                return 'Please enter imageURL';
                              }
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'Please enter valid URL.';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editiedProduct = Product(
                                  id: _editiedProduct.id,
                                  isFavorite: _editiedProduct.isFavorite,
                                  title: _editiedProduct.title,
                                  description: _editiedProduct.description,
                                  price: _editiedProduct.price,
                                  imageUrl: val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
