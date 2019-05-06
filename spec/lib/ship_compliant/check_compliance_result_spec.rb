require "spec_helper"

module ShipCompliant
  describe CheckComplianceResult do
    it_behaves_like "BaseResult"

    context "compliant?" do
      it "successed if the salesorder was compliant" do
        expect(subject.compliant?).to be_truthy
      end

      it "fails if the salesorder was not compliant" do
        result = CheckComplianceResult.new({
          sales_order: { is_compliant: false }
        })

        expect(result.compliant?).to be_falsey
      end
    end

    context "recommended_tax_due" do
      it "gets the tax due as a float" do
        expect(subject.recommended_tax_due).to eq(1372.34)
      end
    end

    context "shipment_sales_tax_rates" do
      it "returns an array of sales tax rates" do
        expect(subject.shipment_sales_tax_rates).to eq([
          {
            :@shipment_key => 'ORDER-KEY',
            freight_sales_tax_rate: {
              :@sales_tax_due => 100.5,
              :@sales_tax_rate => 10.34
            },
            product_sales_tax_rates: {
              product_sales_tax_rate: {
                :@brand_key => 'ABC',
                :@product_key => '123',
                :@sales_tax_due => 12.332,
                :@sales_tax_rate => 0.844
              }
            }
          }
        ])
      end
    end

    context "taxes_for_shipment" do
      it "finds taxes from shipment_key" do
        expect(subject.taxes_for_shipment('ORDER-KEY')).to eq(ShipmentSalesTaxRate.new(
          shipment_key = 'ORDER-KEY',
          freight = FreightSalesTaxRate.new({ sales_tax_due: 100.5, sales_tax_rate: 10.34 }),
          products = [
            ProductSalesTaxRate.new({ brand_key: 'ABC', product_key: '123', sales_tax_due: 12.332, sales_tax_rate: 0.844 })
          ]
        ))
      end
    end

    context "shipment_compliance_rules" do
      it "returns compliance rules as an array" do
        expect(subject.shipment_compliance_rules).to eq([
          {
            is_compliant: true,
            key: 'ORDER-KEY'
          }
        ])
      end
    end

    context "compliance_rules_for_shipment" do
      it "finds compliance rules for shipment" do
        expect(subject.compliance_rules_for_shipment('ORDER-KEY')).to eq(ShipmentCompliance.new({
          is_compliant: true,
          key: 'ORDER-KEY'
        }))
      end
    end

    context "address_validation_result" do
      it "gets the address validation result" do
        expect(subject.address_validation_result).to eq('AddressValidated')
      end
    end

    context "suggested_address" do
      it "returns the suggested address" do
        expect(subject.suggested_address).to eq(SuggestedAddress.new({
          city: 'Bluebell',
          state: 'Ice Cream'
        }))
      end
    end

    subject do
      CheckComplianceResult.new({
        sales_order: {
          is_compliant: true,
          sales_tax_rates: {
            recommended_sales_tax_due: '1372.34',
            shipment_sales_tax_rates: {
              shipment_sales_tax_rate: {
                :@shipment_key => 'ORDER-KEY',
                freight_sales_tax_rate: {
                  :@sales_tax_due => 100.5,
                  :@sales_tax_rate => 10.34
                },
                product_sales_tax_rates: {
                  product_sales_tax_rate: {
                    :@brand_key => 'ABC',
                    :@product_key => '123',
                    :@sales_tax_due => 12.332,
                    :@sales_tax_rate => 0.844
                  }
                }
              }
            }
          },
          shipments: {
            shipment_compliance_response: {
              is_compliant: true,
              key: 'ORDER-KEY'
            }
          }
        },
        address_validation_result: 'AddressValidated',
        suggested_address: {
          city: 'Bluebell',
          state: 'Ice Cream'
        }
      })
    end
  end
end
