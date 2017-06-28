class CreateStandards < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.string     :name,            null: false, unique: true
      t.string     :path
      t.integer    :order
      t.references :subject
    end
    subjects = %w(국어 영어 수학 사회탐구 과학탐구)
    subjects.each do |subject|
      Standard::Subject.create(name: subject, path: subject, order: 0)
    end

    create_table :universities do |t|
      t.string     :name,            null: false, unique: true
      t.string     :location
      t.string     :address
    end
    univs = %w(서울대학교 연세대학교 고려대학교 성균관대학교)
    univs.each do |univ|
      Standard::University.create(name: univ)
    end

    create_table :majors do |t|
      t.string     :name,            null: false, unique: true
    end
    majors = %w(경영학과 경제학과 컴퓨터공학과)
    majors.each do |major|
      Standard::Major.create(name: major)
    end

    create_table :highschools do |t|
      t.string     :name,            null: false, unique: true
      t.string     :location
      t.string     :address
    end
    schools = %w(서울고등학교 대일외국어고등학교 목동고등학교)
    schools.each do |school|
      Standard::Highschool.create(name: school)
    end

    create_table :banks do |t|
      t.string     :name,            null: false, unique: true
    end
    banks = %w(국민은행 기업은행 우리은행 농협 신한은행(조흥) KEB하나은행 한국씨티은행 SC제일은행 경남은행 광주은행 대구은행 도이치 부산은행 비엔피파리바 산림조합 산업 상호저축은행 새마을금고 수출입은행 수협 신협 우체국 전북은행 제주은행 중국공상은행 카카오뱅크 케이뱅크 펀드온라인코리아 BOA HSBC JP모간체이스)
    banks.each do |bank|
      Standard::Bank.create(name: bank)
    end

    create_table :online_providers do |t|
      t.string     :name,            null: false, unique: true
    end
    providers = %w(메가스터디 대성마이맥 스카이에듀 이투스)
    providers.each do |provider|
      Standard::OnlineProvider.create(name: provider)
    end

    create_table :online_teachers do |t|
      t.string     :name,            null: false
      t.string     :uid,             null: false, unique: true
      t.references :online_provider, null: false
    end

    create_table :online_lectures do |t|
      t.references :subject,         null: false
      t.references :online_provider, null: false
      t.string     :uid,             null: false, unique: true
      t.string     :title,           null: false
      t.references :online_teacher,  null: false
      t.string     :target,          default: ''
      t.integer    :lecture_count,   default: 0
      t.boolean    :is_completed,    default: false
      t.string     :package_ids,     default: ''
      t.boolean    :is_collected,    default: false

      t.timestamps
    end

    create_table :online_lecture_lists do |t|
      t.references :online_lecture,  null: false
      t.integer    :order
      t.string     :title,           default: ''
      t.integer    :time,            default: 0

      t.timestamps
    end
  end
end
