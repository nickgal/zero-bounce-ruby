# frozen_string_literal: true

RSpec.describe Zerobounce::Request do
  describe '.new' do
    context 'when middleware in params' do
      let(:middleware) { proc {} }

      it 'uses the middleware' do
        expect(described_class.new(middleware: middleware).middleware).to be(middleware)
      end
    end

    context 'when middleware not in params' do
      it 'uses Zerobounce::Configuration#middleware' do
        expect(described_class.new.middleware).to be(Zerobounce.config.middleware)
      end
    end

    context 'when headers in params' do
      let(:headers) { { user_agent: 'foobar' } }

      it 'uses the headers' do
        expect(described_class.new(headers: headers).headers).to be(headers)
      end
    end

    context 'when headers not in params' do
      it 'uses Zerobounce::Configuration#headers' do
        expect(described_class.new.headers).to be(Zerobounce.config.headers)
      end
    end

    context 'when host in params' do
      let(:host) { 'http://example.com' }

      it 'uses the host' do
        expect(described_class.new(host: host).host).to be(host)
      end
    end

    context 'when host not in params' do
      it 'uses Zerobounce::Configuration#host' do
        expect(described_class.new.host).to be(Zerobounce.config.host)
      end
    end
  end

  describe 'API V1' do
    before { Zerobounce.config.api_version = 'v1' }

    describe '#validate_with_ip' do
      before do
        Zerobounce.config.middleware = proc do |f|
          f.adapter(:test) { |stub| stub.get('/v1/validatewithip') { |_| [200, {}, ''] } }
        end
      end

      it 'returns a response' do
        params = { email: 'user@example.com', ip_address: '127.0.0.1' }
        expect(described_class.new.validate_with_ip(params)).to be_a(Zerobounce::Response)
      end
    end

    describe '#validate' do
      context 'with ip_address' do
        before do
          Zerobounce.config.middleware = proc do |f|
            f.adapter(:test) { |stub| stub.get('/v1/validatewithip') { |_| [200, {}, ''] } }
          end
        end

        it 'returns a response' do
          expect(described_class.new.validate(email: 'user@example.com', ip_address: '127.0.0.1')).to(
            be_a(Zerobounce::Response)
          )
        end
      end

      context 'without ip_address' do
        before do
          Zerobounce.config.middleware = proc do |f|
            f.adapter(:test) { |stub| stub.get('/v1/validate') { |_| [200, {}, {}] } }
          end
        end

        it 'returns a response' do
          expect(described_class.new.validate(email: 'user@example.com')).to be_a(Zerobounce::Response)
        end
      end
    end

    describe '#credits' do
      before do
        Zerobounce.config.middleware = proc do |f|
          f.adapter(:test) { |stub| stub.get('/v1/getcredits') { |_| [200, {}, { Credits: '1' }] } }
        end
      end

      it 'returns an integer' do
        expect(described_class.new.credits).to be_an(Integer)
      end
    end
  end

  describe 'API V2' do
    before { Zerobounce.config.api_version = 'v2' }

    describe '#validate' do
      before do
        Zerobounce.config.middleware = proc do |f|
          f.adapter(:test) { |stub| stub.get('/v2/validate') { |_| [200, {}, ''] } }
        end
      end

      it 'returns a response' do
        expect(described_class.new.validate(email: 'user@example.com')).to be_a(Zerobounce::Response)
      end
    end

    describe '#credits' do
      before do
        Zerobounce.config.middleware = proc do |f|
          f.adapter(:test) { |stub| stub.get('/v2/getcredits') { |_| [200, {}, { Credits: '1' }] } }
        end
      end

      it 'returns an integer' do
        expect(described_class.new.credits).to be_an(Integer)
      end
    end
  end
end
