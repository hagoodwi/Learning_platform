class GroupsController < ApplicationController
    def show
        @group = Group.find(params[:id])
        @users = @group.users
        @userss = User.where.not(id: @group.user_ids)
    end

    def add_user
        # debugger
        @group = Group.find(params[:id])
        @user = User.find(params[:user][:id])
        @group.users << @user
    
        
        redirect_to group_path(@group)
    end

    def add_users
        @group = Group.find(params[:id])
        @userss = User.where.not(id: @group.user_ids)

        debugger
    
        if params[:group][:user_ids].present?
          @users_to_add = User.where(id: params[:group][:user_ids])
          @group.users << @users_to_add if @users_to_add.present?
        end
    
        redirect_to group_path(@group)
    end

    # debugger
end
