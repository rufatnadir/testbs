#load .../Test/features

class AutomatedTestsController < ApplicationController
  before_action :set_automated_test, only: [:show, :edit, :update, :destroy]

  # GET /automated_tests
  # GET /automated_tests.json
  def index
    @automated_tests = AutomatedTest.all
  end

  # GET /automated_tests/1
  # GET /automated_tests/1.json
  def show
  end

  # GET /automated_tests/new
  def new
    @automated_test = AutomatedTest.new
  end

  # GET /automated_tests/1/edit
  def edit
  end

  # POST /automated_tests
  # POST /automated_tests.json
  def create
    @automated_test = AutomatedTest.new(automated_test_params)

    respond_to do |format|
      if @automated_test.save
        format.html { redirect_to @automated_test, notice: 'Automated test was successfully created.' }
        format.json { render :show, status: :created, location: @automated_test }
      else
        format.html { render :new }
        format.json { render json: @automated_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /automated_tests/1
  # PATCH/PUT /automated_tests/1.json
  def update
    respond_to do |format|
      if @automated_test.update(automated_test_params)
        format.html { redirect_to @automated_test, notice: 'Automated test was successfully updated.' + edit_automated_test_path.to_s }
        format.json { render :show, status: :ok, location: @automated_test }
      else
        format.html { render :edit }
        format.json { render json: @automated_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /automated_tests/1
  # DELETE /automated_tests/1.json
  def destroy
    @automated_test.destroy
    respond_to do |format|
      format.html { redirect_to automated_tests_url, notice: 'Automated test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /automated_tests/1
  # PATCH/PUT /automated_tests/1.json
  def run
    @automated_test = AutomatedTest.find(params[:id])
    respond_to do|format|
      if(@automated_test.id > 0)
        run_test(@automated_test.id, @automated_test.filename)
        last_run_text = IO.read("#{Rails.root}/Test/Logs/LogReport_" + @automated_test.filename.to_s[0, @automated_test.filename.to_s.index('.')] + '.log')
        test_passed = if !last_run_text.include? 'failed'
                        true
                      else
                        false
                      end
        @automated_test.update_attributes(:pass => test_passed, :lastrundate => Time.now.to_s, :lastruntext => last_run_text)
        format.html { redirect_to automated_tests_url, notice: 'Automated test ' + @automated_test.filename.to_s + ' ran successfully.' }
      else
        @automated_test.update_attributes(:pass => false, :lastrundate => Time.now.to_s, :lastruntext => 'Invalid test id was specified. Check configuration.')
        format.html { redirect_to automated_tests_url, notice: 'Automated test ' + @automated_test.filename.to_s + ' was unable to run.' }
      end
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_automated_test
      @automated_test = AutomatedTest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def automated_test_params
      params.require(:automated_test).permit(:testid, :int, :name, :description, :lastrundate, :datetime, :pass, :lastruntext, :filename)
    end

    def run_test(test_id, filename)
#      features= File.expand_path('../Test/features/accept_invitation.feature ../Test/features/verify_items_creation_in_db.feature', File.dirname(File.dirname(__FILE__))) # .../Test/features/verify_items_creation_in_db.feature'
      features= File.expand_path('../Test/features/' + filename, File.dirname(File.dirname(__FILE__))) # .../Test/features/verify_items_creation_in_db.feature'
      def config_paths
        {
            :autoload_code_paths => %('..../Test/features' '..../Test/features/step_definitions')
        }
      end

      runtime = Cucumber::Runtime.new(Cucumber::Configuration.new(config_paths))
      runtime.load_programming_language('rb')
      Cucumber::Cli::Main.new([features]).execute!(runtime)

      return 'Test did not run successfully'
  rescue SystemExit => e
      log_contents = IO.read("#{Rails.root}/Test/Logs/LogReport_" + filename.to_s[0, filename.to_s.index('.')] + '.log')

      return log_contents
  end
end
