RSpec.describe MachiiroSupport::Enum do
  describe '.enums_ordinal' do
    let(:enum1) do
      Module.new do
        include MachiiroSupport::Enum

        enums_ordinal :AUTO,
                      :ENTRY,
                      :EXIT
      end
    end

    let(:enum2) do
      Module.new do
        include MachiiroSupport::Enum

        enums_ordinal :AUTO,
                      :ENTRY,
                      :EXIT
      end
    end

    it "`ordinal?` method returns true" do
      expect(enum1.ordinal?).to eq true
    end

    it "`string?` method returns false" do
      expect(enum1.string?).to eq false
    end

    it "`values` method returns Hash including enum" do
      expect(enum1.values).to eq [enum1.AUTO, enum1.ENTRY, enum1.EXIT]
    end

    it "`value_of` method returns enum" do
      aggregate_failures do
        expect(enum1.value_of(1)).to eq enum1.AUTO
        expect(enum1.value_of(2)).to eq enum1.ENTRY
        expect(enum1.value_of(3)).to eq enum1.EXIT
      end
    end

    it "`index_of` method returns index number" do
      aggregate_failures do
        expect(enum1.index_of(1)).to eq 0
        expect(enum1.index_of(2)).to eq 1
        expect(enum1.index_of(3)).to eq 2
      end
    end

    it "raises `NoMethodError` when the method is not defined" do
      expect(enum1.respond_to?(:NOT_DEFINED)).to eq false
      expect { enum1.NOT_DEFINED }.to raise_error(NoMethodError)
    end

    it "`as_json` method of each enumerated type returns Hash" do
      aggregate_failures do
        expect(enum1.AUTO.as_json).to eq({ 'key' => 1, 'order' => 0, 'name' => 'AUTO', 'lower_name' => 'auto', 'auto?' => true, 'entry?' => false, 'exit?' => false })
        expect(enum1.ENTRY.as_json).to eq({ 'key' => 2, 'order' => 1, 'name' => 'ENTRY', 'lower_name' => 'entry', 'auto?' => false, 'entry?' => true, 'exit?' => false })
        expect(enum1.EXIT.as_json).to eq({ 'key' => 3, 'order' => 2, 'name' => 'EXIT', 'lower_name' => 'exit', 'auto?' => false, 'entry?' => false, 'exit?' => true })
      end
    end

    it "`to_json` method of each enumerated type returns JSON string" do
      aggregate_failures do
        expect(JSON.parse(enum1.AUTO.to_json)).to eq enum1.AUTO.as_json
        expect(JSON.parse(enum1.ENTRY.to_json)).to eq enum1.ENTRY.as_json
        expect(JSON.parse(enum1.EXIT.to_json)).to eq enum1.EXIT.as_json
      end
    end

    it "`to_h` method of each enumerated type returns Hash including all attributes" do
      aggregate_failures do
        expect(enum1.AUTO.to_h).to eq({ key: 1, order: 0, name: :AUTO, lower_name: :auto, auto?: true, entry?: false, exit?: false })
        expect(enum1.ENTRY.to_h).to eq({ key: 2, order: 1, name: :ENTRY, lower_name: :entry, auto?: false, entry?: true, exit?: false })
        expect(enum1.EXIT.to_h).to eq({ key: 3, order: 2, name: :EXIT, lower_name: :exit, auto?: false, entry?: false, exit?: true })
      end
    end

    it "raises `NoMethodError` when the method of each enumerated type is not defined" do
      aggregate_failures do
        expect(enum1.AUTO.respond_to?(:not_defined)).to eq false
        expect { enum1.AUTO.not_defined }.to raise_error(NoMethodError)

        expect(enum1.ENTRY.respond_to?(:not_defined)).to eq false
        expect { enum1.ENTRY.not_defined }.to raise_error(NoMethodError)

        expect(enum1.EXIT.respond_to?(:not_defined)).to eq false
        expect { enum1.EXIT.not_defined }.to raise_error(NoMethodError)
      end
    end

    it "each enumerated type can be accessed" do
      aggregate_failures do
        expect(enum1.AUTO.key).to eq 1
        expect(enum1.AUTO.order).to eq 0
        expect(enum1.AUTO.name).to eq :AUTO
        expect(enum1.AUTO.instance_variable_get(:@namespace)).to eq enum1

        expect(enum1.ENTRY.key).to eq 2
        expect(enum1.ENTRY.order).to eq 1
        expect(enum1.ENTRY.name).to eq :ENTRY
        expect(enum1.ENTRY.instance_variable_get(:@namespace)).to eq enum1

        expect(enum1.EXIT.key).to eq 3
        expect(enum1.EXIT.order).to eq 2
        expect(enum1.EXIT.name).to eq :EXIT
        expect(enum1.EXIT.instance_variable_get(:@namespace)).to eq enum1
      end
    end

    it "each enumerated type should have inquiry method" do
      aggregate_failures do
        expect(enum1.AUTO.auto?).to eq true
        expect(enum1.AUTO.entry?).to eq false
        expect(enum1.AUTO.exit?).to eq false

        expect(enum1.ENTRY.auto?).to eq false
        expect(enum1.ENTRY.entry?).to eq true
        expect(enum1.ENTRY.exit?).to eq false

        expect(enum1.EXIT.auto?).to eq false
        expect(enum1.EXIT.entry?).to eq false
        expect(enum1.EXIT.exit?).to eq true
      end
    end

    it "the enumerated types of enum1 and enum2 are same" do
      expect(enum1.AUTO == :AUTO).to eq false
      expect(Set.new([enum1.AUTO])).to include enum2.AUTO # for hash comparison
      expect(enum1.values).to eq enum2.values
    end

    context 'with attributes' do
      let(:enum1) do
        Module.new do
          include MachiiroSupport::Enum

          enums_ordinal [:AUTO, label: ''],
                        [:ENTRY, label: '入館'],
                        [:EXIT, label: '退館']
        end
      end

      it "each enumerated type can be accessed" do
        aggregate_failures do
          expect(enum1.AUTO.key).to eq 1
          expect(enum1.AUTO.order).to eq 0
          expect(enum1.AUTO.name).to eq :AUTO
          expect(enum1.AUTO.label).to eq ''
          expect(enum1.AUTO.instance_variable_get(:@namespace)).to eq enum1

          expect(enum1.ENTRY.key).to eq 2
          expect(enum1.ENTRY.order).to eq 1
          expect(enum1.ENTRY.name).to eq :ENTRY
          expect(enum1.ENTRY.label).to eq '入館'
          expect(enum1.ENTRY.instance_variable_get(:@namespace)).to eq enum1

          expect(enum1.EXIT.key).to eq 3
          expect(enum1.EXIT.order).to eq 2
          expect(enum1.EXIT.name).to eq :EXIT
          expect(enum1.EXIT.label).to eq '退館'
          expect(enum1.EXIT.instance_variable_get(:@namespace)).to eq enum1
        end
      end
    end
  end

  describe '.enums_string' do
    let(:enum1) do
      Module.new do
        include MachiiroSupport::Enum

        enums_string :NONE,
                     :ONLY_RESERVED,
                     :ONLY_ATTENDED
      end
    end

    let(:enum2) do
      Module.new do
        include MachiiroSupport::Enum

        enums_string :NONE,
                     :ONLY_RESERVED,
                     :ONLY_ATTENDED
      end
    end

    it "`ordinal?` method returns false" do
      expect(enum1.ordinal?).to eq false
    end

    it "`string?` method returns true" do
      expect(enum1.string?).to eq true
    end

    it "`values` method returns Hash including enum" do
      expect(enum1.values).to eq [enum1.NONE, enum1.ONLY_RESERVED, enum1.ONLY_ATTENDED]
    end

    it "`value_of` method returns enum" do
      expect(enum1.value_of('NONE')).to eq enum1.NONE
      expect(enum1.value_of('ONLY_RESERVED')).to eq enum1.ONLY_RESERVED
      expect(enum1.value_of('ONLY_ATTENDED')).to eq enum1.ONLY_ATTENDED
    end

    it "`index_of` method returns index number" do
      expect(enum1.index_of('NONE')).to eq 0
      expect(enum1.index_of('ONLY_RESERVED')).to eq 1
      expect(enum1.index_of('ONLY_ATTENDED')).to eq 2
    end

    it "each enumerated type can be accessed" do
      aggregate_failures do
        expect(enum1.NONE.key).to eq 'NONE'
        expect(enum1.NONE.order).to eq 0
        expect(enum1.NONE.name).to eq :NONE
        expect(enum1.NONE.instance_variable_get(:@namespace)).to eq enum1

        expect(enum1.ONLY_RESERVED.key).to eq 'ONLY_RESERVED'
        expect(enum1.ONLY_RESERVED.order).to eq 1
        expect(enum1.ONLY_RESERVED.name).to eq :ONLY_RESERVED
        expect(enum1.ONLY_RESERVED.instance_variable_get(:@namespace)).to eq enum1

        expect(enum1.ONLY_ATTENDED.key).to eq 'ONLY_ATTENDED'
        expect(enum1.ONLY_ATTENDED.order).to eq 2
        expect(enum1.ONLY_ATTENDED.name).to eq :ONLY_ATTENDED
        expect(enum1.ONLY_ATTENDED.instance_variable_get(:@namespace)).to eq enum1
      end
    end

    it "enum should have inquiry method" do
      aggregate_failures do
        expect(enum1.NONE.none?).to eq true
        expect(enum1.NONE.only_reserved?).to eq false
        expect(enum1.NONE.only_attended?).to eq false

        expect(enum1.ONLY_RESERVED.none?).to eq false
        expect(enum1.ONLY_RESERVED.only_reserved?).to eq true
        expect(enum1.ONLY_RESERVED.only_attended?).to eq false

        expect(enum1.ONLY_ATTENDED.none?).to eq false
        expect(enum1.ONLY_ATTENDED.only_reserved?).to eq false
        expect(enum1.ONLY_ATTENDED.only_attended?).to eq true
      end
    end

    it "the enumerated types of enum1 and enum2 are same" do
      expect(enum1.values).to eq enum2.values
    end

    context 'with attributes' do
      let(:enum1) do
        Module.new do
          include MachiiroSupport::Enum

          enums_string [:ADMIN, settings_key: :admin],
                       [:FRONT, settings_key: :front]
        end
      end

      it "each enumerated type can be accessed" do
        aggregate_failures do
          expect(enum1.ADMIN.key).to eq 'ADMIN'
          expect(enum1.ADMIN.order).to eq 0
          expect(enum1.ADMIN.name).to eq :ADMIN
          expect(enum1.ADMIN.settings_key).to eq :admin
          expect(enum1.ADMIN.instance_variable_get(:@namespace)).to eq enum1

          expect(enum1.FRONT.key).to eq 'FRONT'
          expect(enum1.FRONT.order).to eq 1
          expect(enum1.FRONT.name).to eq :FRONT
          expect(enum1.FRONT.settings_key).to eq :front
          expect(enum1.FRONT.instance_variable_get(:@namespace)).to eq enum1
        end
      end
    end
  end
end
