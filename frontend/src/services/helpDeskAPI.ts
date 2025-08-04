// Help Desk API Service

export interface Ticket {
  id: number;
  title: string;
  description: string;
  category: string;
  priority: 'LOW' | 'MEDIUM' | 'HIGH' | 'URGENT';
  status: 'OPEN' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED';
  createdBy: string;
  createdByPhone: string;
  assignedTo?: string;
  createdAt: string;
  updatedAt: string;
  responses: TicketResponse[];
}

export interface TicketResponse {
  id: number;
  ticketId: number;
  message: string;
  respondedBy: string;
  respondedByRole: string;
  createdAt: string;
}

export interface TicketForm {
  title: string;
  description: string;
  category: string;
  priority: 'LOW' | 'MEDIUM' | 'HIGH' | 'URGENT';
}

export interface TicketStatistics {
  totalTickets: number;
  openTickets: number;
  inProgressTickets: number;
  resolvedTickets: number;
  closedTickets: number;
  urgentTickets: number;
  highPriorityTickets: number;
}

const API_BASE_URL = '/api/help-desk';

class HelpDeskAPI {
  // Create a new ticket
  async createTicket(ticketData: TicketForm, userInfo: { fullName: string; phone: string }): Promise<Ticket> {
    const response = await fetch(`${API_BASE_URL}/tickets`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        ...ticketData,
        createdBy: userInfo.fullName,
        createdByPhone: userInfo.phone,
      }),
    });

    if (!response.ok) {
      throw new Error('Failed to create ticket');
    }

    return response.json();
  }

  // Get all tickets (for admin)
  async getAllTickets(): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch tickets');
    }

    return response.json();
  }

  // Get tickets by user phone (for parents)
  async getTicketsByUserPhone(userPhone: string): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/user/${userPhone}`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch user tickets');
    }

    return response.json();
  }

  // Get ticket by ID
  async getTicketById(ticketId: number): Promise<Ticket> {
    const response = await fetch(`${API_BASE_URL}/tickets/${ticketId}`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch ticket');
    }

    return response.json();
  }

  // Update ticket status
  async updateTicketStatus(ticketId: number, status: Ticket['status']): Promise<Ticket> {
    const response = await fetch(`${API_BASE_URL}/tickets/${ticketId}/status`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ status }),
    });

    if (!response.ok) {
      throw new Error('Failed to update ticket status');
    }

    return response.json();
  }

  // Assign ticket to admin
  async assignTicket(ticketId: number, assignedTo: string): Promise<Ticket> {
    const response = await fetch(`${API_BASE_URL}/tickets/${ticketId}/assign`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ assignedTo }),
    });

    if (!response.ok) {
      throw new Error('Failed to assign ticket');
    }

    return response.json();
  }

  // Add response to ticket
  async addResponse(ticketId: number, responseData: { message: string; respondedBy: string; respondedByRole: string }): Promise<TicketResponse> {
    const response = await fetch(`${API_BASE_URL}/tickets/${ticketId}/responses`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(responseData),
    });

    if (!response.ok) {
      throw new Error('Failed to add response');
    }

    return response.json();
  }

  // Get responses for a ticket
  async getTicketResponses(ticketId: number): Promise<TicketResponse[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/${ticketId}/responses`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch ticket responses');
    }

    return response.json();
  }

  // Get tickets by status
  async getTicketsByStatus(status: Ticket['status']): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/status/${status}`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch tickets by status');
    }

    return response.json();
  }

  // Get tickets by priority
  async getTicketsByPriority(priority: Ticket['priority']): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/priority/${priority}`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch tickets by priority');
    }

    return response.json();
  }

  // Get tickets by category
  async getTicketsByCategory(category: string): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/category/${encodeURIComponent(category)}`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch tickets by category');
    }

    return response.json();
  }

  // Get recent tickets
  async getRecentTickets(): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/recent`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch recent tickets');
    }

    return response.json();
  }

  // Get tickets without responses
  async getTicketsWithoutResponses(): Promise<Ticket[]> {
    const response = await fetch(`${API_BASE_URL}/tickets/unresponded`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch unresponded tickets');
    }

    return response.json();
  }

  // Get ticket statistics
  async getTicketStatistics(): Promise<TicketStatistics> {
    const response = await fetch(`${API_BASE_URL}/statistics`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch ticket statistics');
    }

    return response.json();
  }

  // Get available categories
  async getCategories(): Promise<string[]> {
    const response = await fetch(`${API_BASE_URL}/categories`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch categories');
    }

    return response.json();
  }

  // Get available priorities
  async getPriorities(): Promise<string[]> {
    const response = await fetch(`${API_BASE_URL}/priorities`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch priorities');
    }

    return response.json();
  }

  // Get available statuses
  async getStatuses(): Promise<string[]> {
    const response = await fetch(`${API_BASE_URL}/statuses`);
    
    if (!response.ok) {
      throw new Error('Failed to fetch statuses');
    }

    return response.json();
  }
}

export const helpDeskAPI = new HelpDeskAPI(); 