require "spec_helper"

module ShipCompliant
  describe GetSalesOrderExtendedResult do
    it_behaves_like "BaseResult"

    context "shipment_compliance_rules" do
      it "returns compliance rules as an array" do
        expect(subject.shipment_compliance_rules).to eq([
          {
            is_compliant: true,
            key: 'SHIPMENT-KEY',
          }
        ])
      end
    end

    context "compliance_rules_for_shipment" do
      it "finds compliance rules for shipment" do
        expect(subject.compliance_rules_for_shipment('SHIPMENT-KEY')).to eq(ShipmentCompliance.new({
          is_compliant: true,
          key: 'SHIPMENT-KEY'
        }))
      end
    end

    context "bill_to" do
      it "returns an Address" do
        expect(subject.bill_to).to eq(Address.new({
          city: 'Jellystone Park',
          state: 'WY'
        }))
      end
    end

    context "shipments" do
      it "returns an array of shipments" do
        expect(subject.shipments).to eq([{
          shipment_key: 'SHIPMENT-KEY',
          shipment_items: []
        }])
      end
    end

    context "find_shipment" do
      it "returns the shipment" do
        expect(subject.find_shipment('SHIPMENT-KEY')).to eq(Shipment.new({
          shipment_key: 'SHIPMENT-KEY',
          shipment_items: []
        }))
      end
    end

    context "channel_details" do
      it "returns the details" do
        expect(subject.channel_details).to eq(ChannelDetails.new(some_details: 'online sales'))
      end
    end

    subject do
      GetSalesOrderExtendedResult.new({
        compliance_results: {
          sales_order: {
            shipments: {shipment_compliance_response: [{ is_compliant: true, key: 'SHIPMENT-KEY' }]}
          }
        },
        sales_order: {
          bill_to: {
            city: 'Jellystone Park',
            state: 'WY'
          },
          shipments: [shipment]
        },
        order_channel_details: {
          some_details: 'online sales'
        }
      })
    end

    let(:shipment) do
      {shipment: { shipment_key: 'SHIPMENT-KEY', shipment_items: [] }}
    end
  end
end
